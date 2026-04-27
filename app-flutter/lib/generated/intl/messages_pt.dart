// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt';

  static String m0(episodes) =>
      "${Intl.plural(episodes, zero: '≈ 0 episódios', one: '≈ 1 episódio', other: '≈ ${episodes} episódios')}";

  static String m1(coins) =>
      "${Intl.plural(coins, zero: '0 moeda', one: '1 moeda', other: '${coins} moedas')}";

  static String m2(username) =>
      "Tem certeza de que deseja excluir a conta ${username}?";

  static String m3(username) =>
      "Aviso: Excluir sua conta, ${username}, não é o mesmo que sair.\n\nDepois de excluir sua conta, todos os seus dados, incluindo preferências e histórico salvos, serão apagados permanentemente.\n\nTodas as assinaturas ou compras ativas vinculadas à sua conta não serão mais associadas a ela e não poderão ser recuperadas.\n\nEsta ação é permanente e não pode ser desfeita.\n\nConfirme somente se tiver certeza de que deseja prosseguir.";

  static String m4(coins, price) =>
      "Você pode recarregar ${coins} por apenas ${price}. Tem certeza de que deseja desistir?";

  static String m5(store) =>
      "- Sua conta ${store} será cobrada automaticamente pela renovação 24 horas antes do final do período de assinatura.\n- Se você quiser cancelar sua assinatura, acesse a página de gerenciamento de assinatura do ${store} para cancelar.\n- Devido à rede e outros motivos, o processamento da compra pode ser atrasado. Atualize a página após a compra ser bem-sucedida.\n- Se você tiver alguma dúvida, entre em contato conosco.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Sobre"),
        "about_eposides_num": m0,
        "app_name": MessageLookupByLibrary.simpleMessage("Ume"),
        "auto_unlock_next_video": MessageLookupByLibrary.simpleMessage(
            "Desbloqueio automático do próximo vídeo"),
        "back": MessageLookupByLibrary.simpleMessage("Voltar"),
        "balance": MessageLookupByLibrary.simpleMessage("Equilíbrio"),
        "bonus": MessageLookupByLibrary.simpleMessage("Bonus"),
        "can_be_changed_in_settings": MessageLookupByLibrary.simpleMessage(
            "Pode ser alterado nas configurações"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "check_in": MessageLookupByLibrary.simpleMessage("Registro"),
        "checked_in": MessageLookupByLibrary.simpleMessage("Registrado"),
        "claim": MessageLookupByLibrary.simpleMessage("Alegar"),
        "coins": MessageLookupByLibrary.simpleMessage("Moedas"),
        "coins_all_supper": MessageLookupByLibrary.simpleMessage("MOEDAS"),
        "coins_num": m1,
        "consumption": MessageLookupByLibrary.simpleMessage("Consumo"),
        "contact_us": MessageLookupByLibrary.simpleMessage("Contate-nos"),
        "daily_check_in":
            MessageLookupByLibrary.simpleMessage("Check-in diário"),
        "daily_check_in_des0":
            MessageLookupByLibrary.simpleMessage("Você fez check-in há"),
        "daily_check_in_des2":
            MessageLookupByLibrary.simpleMessage("dias consecutivos!"),
        "day": MessageLookupByLibrary.simpleMessage("Dia"),
        "delete": MessageLookupByLibrary.simpleMessage("Excluir"),
        "delete_account": MessageLookupByLibrary.simpleMessage("Excluir conta"),
        "delete_account_confirm": m2,
        "delete_account_desc": m3,
        "delete_account_success": MessageLookupByLibrary.simpleMessage(
            "Bem-sucedido, será totalmente processado em 15 dias"),
        "done": MessageLookupByLibrary.simpleMessage("Feito"),
        "earn_rewards":
            MessageLookupByLibrary.simpleMessage("Ganhe recompensas"),
        "empty_list_hint":
            MessageLookupByLibrary.simpleMessage("Está vazio aqui"),
        "empty_page": MessageLookupByLibrary.simpleMessage("Página vazia"),
        "empty_refresh_prompt": MessageLookupByLibrary.simpleMessage(
            "Algo está errado, toque para atualizar"),
        "enjoy_all_dramas_for_free": MessageLookupByLibrary.simpleMessage(
            "Aproveite todos os dramas de graça"),
        "error_toast": MessageLookupByLibrary.simpleMessage(
            "Erro, tente novamente mais tarde"),
        "error_try_again_later": MessageLookupByLibrary.simpleMessage(
            "Algo está errado, tente novamente mais tarde"),
        "expires_in": MessageLookupByLibrary.simpleMessage("Expira em"),
        "free_watch": MessageLookupByLibrary.simpleMessage("Assistir Grátis"),
        "give_up": MessageLookupByLibrary.simpleMessage("Desistir"),
        "go": MessageLookupByLibrary.simpleMessage("Ir"),
        "home": MessageLookupByLibrary.simpleMessage("Início"),
        "income": MessageLookupByLibrary.simpleMessage("Renda"),
        "language": MessageLookupByLibrary.simpleMessage("Linguagem"),
        "log_out": MessageLookupByLibrary.simpleMessage("Sair"),
        "log_out_check_msg": MessageLookupByLibrary.simpleMessage(
            "Tem certeza que deseja sair?"),
        "login_app": MessageLookupByLibrary.simpleMessage("Login"),
        "miss_out_stories_prompt": MessageLookupByLibrary.simpleMessage(
            "Não perca as histórias intermediárias"),
        "mobisen_pro": MessageLookupByLibrary.simpleMessage("Ume Pro"),
        "month": MessageLookupByLibrary.simpleMessage("mês"),
        "monthly_pro": MessageLookupByLibrary.simpleMessage("Mensal Pro"),
        "my_bonus": MessageLookupByLibrary.simpleMessage("Meu bonus"),
        "my_coins": MessageLookupByLibrary.simpleMessage("Minhas moedas"),
        "my_list": MessageLookupByLibrary.simpleMessage("Minha lista"),
        "my_wallet": MessageLookupByLibrary.simpleMessage("Minha carteira"),
        "network_error": MessageLookupByLibrary.simpleMessage("Erro de rede"),
        "new_user_product_give_up_msg": m4,
        "new_user_product_msg": MessageLookupByLibrary.simpleMessage(
            "Exclusivamente para novos usuários. Tempo limitado"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notificações"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "popular": MessageLookupByLibrary.simpleMessage("Popular"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Política de Privacidade"),
        "profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "purchase_successful": MessageLookupByLibrary.simpleMessage(
            "Compra realizada com sucesso"),
        "purchase_tips": m5,
        "redirect": MessageLookupByLibrary.simpleMessage("Redirecionar"),
        "rewards": MessageLookupByLibrary.simpleMessage("Recompensas"),
        "series": MessageLookupByLibrary.simpleMessage("Series"),
        "settings": MessageLookupByLibrary.simpleMessage("Configurações"),
        "share": MessageLookupByLibrary.simpleMessage("Compartilhar"),
        "share_app": MessageLookupByLibrary.simpleMessage("Compartilhe"),
        "share_app_msg": MessageLookupByLibrary.simpleMessage(
            "Ume: Histórias incríveis te esperando. Comece a assistir agora!"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Entrar"),
        "sign_in_email_conflict_prompt": MessageLookupByLibrary.simpleMessage(
            "Já existe uma conta com este e-mail, mas com um provedor diferente"),
        "sign_in_error": MessageLookupByLibrary.simpleMessage("Erro de login"),
        "sign_in_policy_hint": MessageLookupByLibrary.simpleMessage(
            "Se continuar, você concorda com nossos"),
        "sign_in_with": MessageLookupByLibrary.simpleMessage("Faça login com"),
        "tasks": MessageLookupByLibrary.simpleMessage("Tarefas"),
        "terms_of_service":
            MessageLookupByLibrary.simpleMessage("Termos de serviço"),
        "this_episode": MessageLookupByLibrary.simpleMessage("Este episódio"),
        "top_up": MessageLookupByLibrary.simpleMessage("Completar"),
        "try_again_later": MessageLookupByLibrary.simpleMessage(
            "Por favor, tente novamente mais tarde"),
        "unlock_all_series":
            MessageLookupByLibrary.simpleMessage("Desbloquear todas as séries"),
        "unlock_btn": MessageLookupByLibrary.simpleMessage("Desbloquear agora"),
        "unlock_episode":
            MessageLookupByLibrary.simpleMessage("Desbloquear episódio"),
        "vip_all_supper": MessageLookupByLibrary.simpleMessage("VIP"),
        "watch_ad": MessageLookupByLibrary.simpleMessage("Assistir anúncios"),
        "watch_episode":
            MessageLookupByLibrary.simpleMessage("Assistir episódio"),
        "watch_history":
            MessageLookupByLibrary.simpleMessage("Histórico de exibição"),
        "watch_history_clear_check_msg": MessageLookupByLibrary.simpleMessage(
            "Tem certeza de que deseja limpar o histórico de exibição?"),
        "watch_stories":
            MessageLookupByLibrary.simpleMessage("Assistir histórias"),
        "week": MessageLookupByLibrary.simpleMessage("semana"),
        "weekly_pro": MessageLookupByLibrary.simpleMessage("Semanal Pro"),
        "year": MessageLookupByLibrary.simpleMessage("ano"),
        "yearly_pro": MessageLookupByLibrary.simpleMessage("Anual Pro")
      };
}
