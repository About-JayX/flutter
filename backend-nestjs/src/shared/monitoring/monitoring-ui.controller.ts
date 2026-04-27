import { Controller, Get, Res, Post } from '@nestjs/common';
import { Response } from 'express';
import { QueueMonitoringService } from './queue-monitoring.service';
import { Public } from '@/modules/auth/decorators/public.decorator';

@Controller('admin')  // 基础路径 /admin
export class MonitoringUiController {
  constructor(private readonly monitoringService: QueueMonitoringService) {}

  /**
   * 页面一键“重试所有失败任务”专用
   * 返回 JSON 给前端 AJAX
   */
//   @Post('queues/retry-all-failed')
//   async retryAllFailed() {
//     // 直接调用业务服务，true=只重试失败任务
//     const ret = await this.monitoringService.retryAllFailedJobs();
//     return { success: true, retried: ret.length };
//   }

  @Public()
  @Get('queues')  // 完整路径: /admin/queues
  async getQueueDashboard(@Res() res: Response) {
    try {
      const [stats, recentJobs, metrics, jobCounts] = await Promise.all([
        this.monitoringService.getQueueStats(),
        this.monitoringService.getRecentJobs(30),
        this.monitoringService.getQueueMetrics(),
        this.monitoringService.getJobCounts(),
      ]);

      const html = this.generateDashboardHtml(stats, recentJobs, metrics, jobCounts);
      res.send(html);
    } catch (error) {
      console.error('Dashboard error:', error);
      res.status(500).send(this.generateErrorHtml(error));
    }
  }

  @Get('queues/simple')  // 简化版本: /admin/queues/simple
  async getSimpleDashboard(@Res() res: Response) {
    try {
      const stats = await this.monitoringService.getQueueStats();
      const recentJobs = await this.monitoringService.getRecentJobs(10);
      
      const html = this.generateSimpleHtml(stats, recentJobs);
      res.send(html);
    } catch (error) {
      res.status(500).send('Error loading dashboard: ' + error.message);
    }
  }

  private generateDashboardHtml(stats: any, jobs: any[], metrics: any, jobCounts: any): string {
    return `
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>队列监控面板 - Activity System</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #2563eb;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #8b5cf6;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .header h1 {
            color: #1f2937;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #6b7280;
            font-size: 1.2em;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }
        
        .stat-card.waiting { border-top: 4px solid var(--primary); }
        .stat-card.active { border-top: 4px solid var(--warning); }
        .stat-card.completed { border-top: 4px solid var(--success); }
        .stat-card.failed { border-top: 4px solid var(--danger); }
        .stat-card.delayed { border-top: 4px solid var(--info); }
        
        .stat-number {
            font-size: 3em;
            font-weight: bold;
            margin: 15px 0;
        }
        
        .waiting .stat-number { color: var(--primary); }
        .active .stat-number { color: var(--warning); }
        .completed .stat-number { color: var(--success); }
        .failed .stat-number { color: var(--danger); }
        .delayed .stat-number { color: var(--info); }
        
        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin: 25px 0;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-primary { background: var(--primary); color: white; }
        .btn-success { background: var(--success); color: white; }
        .btn-danger { background: var(--danger); color: white; }
        .btn-warning { background: var(--warning); color: white; }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 1024px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .chart-container, .jobs-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .chart-container {
            height: 400px;
        }
        
        .jobs-container {
            max-height: 600px;
            overflow-y: auto;
        }
        
        .job-item {
            padding: 20px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.2s ease;
        }
        
        .job-item:hover {
            background-color: #f9fafb;
        }
        
        .job-item:last-child {
            border-bottom: none;
        }
        
        .job-info h4 {
            margin-bottom: 5px;
            color: #1f2937;
        }
        
        .job-meta {
            color: #6b7280;
            font-size: 0.9em;
        }
        
        .job-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .state-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: 600;
            color: white;
        }
        
        .state-waiting { background: var(--primary); }
        .state-active { background: var(--warning); }
        .state-completed { background: var(--success); }
        .state-failed { background: var(--danger); }
        .state-delayed { background: var(--info); }
        
        .small-btn {
            padding: 6px 12px;
            font-size: 0.8em;
            border-radius: 6px;
        }
        
        .timestamp {
            font-size: 0.8em;
            color: #9ca3af;
            margin-top: 5px;
        }
        
        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 10px;
            border-radius: 6px;
            margin-top: 5px;
            font-size: 0.9em;
        }
        
        .last-updated {
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            margin-top: 20px;
            font-size: 0.9em;
        }
        
        .auto-refresh {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            margin-top: 10px;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 活动队列监控面板</h1>
            <p>实时监控活动完成队列的状态和任务执行情况</p>
            
            <div class="actions">
                <button class="btn btn-primary" onclick="refreshData()">
                    🔄 刷新数据
                </button>
                <button class="btn btn-success" onclick="retryAllFailed()">
                🔄 重试所有失败任务
                </button>

                <a class="btn btn-danger" href="/api/monitoring/clean?type=completed" onclick="return confirm('确定要清理已完成的任务吗？')">
                    🗑️ 清理已完成任务
                </a>
                <a class="btn btn-warning" href="/api" target="_blank">
                    📚 API 文档
                </a>
            </div>
            
            <div class="auto-refresh">
                <input type="checkbox" id="autoRefresh" checked onchange="toggleAutoRefresh()">
                <label for="autoRefresh">每30秒自动刷新</label>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card waiting">
                <div>等待中</div>
                <div class="stat-number">${stats.waiting}</div>
                <div>任务等待执行</div>
            </div>
            <div class="stat-card active">
                <div>执行中</div>
                <div class="stat-number">${stats.active}</div>
                <div>正在处理的任务</div>
            </div>
            <div class="stat-card completed">
                <div>已完成</div>
                <div class="stat-number">${stats.completed}</div>
                <div>成功完成的任务</div>
            </div>
            <div class="stat-card failed">
                <div>已失败</div>
                <div class="stat-number">${stats.failed}</div>
                <div>执行失败的任务</div>
            </div>
            <div class="stat-card delayed">
                <div>已延迟</div>
                <div class="stat-number">${stats.delayed}</div>
                <div>延迟执行的任务</div>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="chart-container">
                <canvas id="jobsChart"></canvas>
            </div>
            
            <div class="jobs-container">
                <h3 style="margin-bottom: 20px; color: #1f2937;">最近任务 (${jobs.length})</h3>
                ${jobs.length === 0 ? 
                    '<div style="text-align: center; padding: 40px; color: #6b7280;">暂无任务</div>' :
                    jobs.map(job => `
                    <div class="job-item">
                        <div class="job-info">
                            <h4>${this.escapeHtml(job.name)}</h4>
                            <h4>${job.data?.title}</h4>
                            <div class="job-meta">
                                ID: ${job.id} | 进度: ${job.progress}%
                            </div>
                            <div class="timestamp">
                                创建时间: ${new Date(job.timestamp).toLocaleString('zh-CN')}
                            </div>
                            ${job.failedReason ? `
                                <div class="error-message">
                                    ❌ 错误: ${this.escapeHtml(job.failedReason)}
                                </div>
                            ` : ''}
                        </div>
                        <div class="job-actions">
                            <span class="state-badge state-${job.state}">
                                ${this.getStateText(job.state)}
                            </span>
                            ${job.state === 'failed' ? `
                                <a class="btn btn-success small-btn" 
                                   href="/api/monitoring/jobs/${job.id}/retry"
                                   onclick="return confirm('确定要重试这个任务吗？')">
                                    重试
                                </a>
                            ` : ''}
                        </div>
                    </div>
                `).join('')}
            </div>
        </div>
        
        <div class="last-updated">
            最后更新: ${new Date().toLocaleString('zh-CN')}
        </div>
    </div>

    <script>
        // 初始化图表
        const ctx = document.getElementById('jobsChart').getContext('2d');
        const chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['等待中', '执行中', '已完成', '已失败', '已延迟'],
                datasets: [{
                    data: [${stats.waiting}, ${stats.active}, ${stats.completed}, ${stats.failed}, ${stats.delayed}],
                    backgroundColor: [
                        '#2563eb', '#f59e0b', '#10b981', '#ef4444', '#8b5cf6'
                    ],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true,
                            font: {
                                size: 12
                            }
                        }
                    },
                    title: {
                        display: true,
                        text: '任务分布统计',
                        font: {
                            size: 16
                        }
                    }
                },
                cutout: '60%'
            }
        });

        let autoRefreshInterval;
        
        function refreshData() {
            window.location.reload();
        }
        
        function toggleAutoRefresh() {
            const checkbox = document.getElementById('autoRefresh');
            if (checkbox.checked) {
                autoRefreshInterval = setInterval(refreshData, 30000);
            } else {
                clearInterval(autoRefreshInterval);
            }
        }
        
        // 启动自动刷新
        toggleAutoRefresh();
        
        // 页面可见性变化时处理自动刷新
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                clearInterval(autoRefreshInterval);
            } else {
                const checkbox = document.getElementById('autoRefresh');
                if (checkbox.checked) {
                    autoRefreshInterval = setInterval(refreshData, 30000);
                }
            }
        });

        async function retryAllFailed() {
        if (!confirm('确定要重试所有失败的任务吗？')) return;
        try {
            const res = await fetch('/api/monitoring/retry-all-failed', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
            });
            const data = await res.json();
            alert('✅成功执行：' + data?.success + ' 个任务 ----- ❌失败执行：' + data?.failed + ' 个任务');
            location.reload();          // 刷新看最新状态
        } catch (e) {
            alert('重试失败：' + e.message);
        }
        }
    </script>
</body>
</html>
    `;
  }

  private generateSimpleHtml(stats: any, jobs: any[]): string {
    return `
<!DOCTYPE html>
<html>
<head>
    <title>简易队列监控</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .stats { background: #f5f5f5; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .job { border: 1px solid #ddd; padding: 10px; margin: 5px 0; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>简易队列监控</h1>
    <div class="stats">
        <h2>队列统计</h2>
        <p>等待: ${stats.waiting} | 执行中: ${stats.active} | 完成: ${stats.completed}</p>
        <p>失败: ${stats.failed} | 延迟: ${stats.delayed} | 暂停: ${stats.paused}</p>
    </div>
    <h2>最近任务</h2>
    ${jobs.map(job => `
        <div class="job">
            <strong>${job.name}</strong> (${job.state})
            <br>ID: ${job.id} | 进度: ${job.progress}%
            ${job.failedReason ? `<br>错误: ${job.failedReason}` : ''}
        </div>
    `).join('')}
    <p><a href="/api/monitoring/stats">JSON API</a></p>
</body>
</html>
    `;
  }

  private generateErrorHtml(error: any): string {
    return `
<!DOCTYPE html>
<html>
<head>
    <title>错误 - 监控面板</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; text-align: center; }
        .error { color: #dc2626; background: #fee2e2; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>😕 加载监控面板时出错</h1>
    <div class="error">
        <h2>错误信息</h2>
        <p>${error.message}</p>
    </div>
    <p><a href="/admin/queues/simple">尝试简易版本</a></p>
    <p><a href="/api/monitoring/stats">查看 JSON 数据</a></p>
</body>
</html>
    `;
  }

  private escapeHtml(unsafe: string): string {
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  private getStateText(state: string): string {
    const states: { [key: string]: string } = {
      'waiting': '等待中',
      'active': '执行中', 
      'completed': '已完成',
      'failed': '已失败',
      'delayed': '已延迟'
    };
    return states[state] || state;
  }
}