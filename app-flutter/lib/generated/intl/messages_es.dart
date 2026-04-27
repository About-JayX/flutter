// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(episodes) =>
      "${Intl.plural(episodes, zero: '≈ 0 episodios', one: '≈ 1 episodio', other: '≈ ${episodes} episodios')}";

  static String m1(coins) =>
      "${Intl.plural(coins, zero: '0 moneda', one: '1 moneda', other: '${coins} monedas')}";

  static String m2(username) =>
      "¿Está seguro de que desea eliminar la cuenta ${username}?";

  static String m3(username) =>
      "Advertencia: Eliminar su cuenta, ${username}, no es lo mismo que cerrar sesión.\n\nUna vez que elimine su cuenta, todos sus datos, incluidas las preferencias guardadas y el historial, se borrarán de forma permanente.\n\nTodas las suscripciones o compras activas vinculadas a tu cuenta ya no estarán asociadas a ella y no podrán recuperarse.\n\nEsta acción es permanente y no se puede deshacer.\n\nConfirme solo si está seguro de que desea continuar.";

  static String m4(coins, price) =>
      "Puedes recargar ${coins} por solo ${price}, ¿estás seguro de que deseas renunciar a ello?";

  static String m5(store) =>
      "- A su cuenta de ${store} se le cobrará automáticamente la renovación dentro de las 24 horas anteriores al final del período de suscripción.\n- Si desea cancelar su suscripción, vaya a la página de administración de suscripciones de ${store} para cancelar.\n- Debido a la red y otros motivos, el procesamiento de la compra puede retrasarse. Actualice la página después de que la compra se haya realizado correctamente.\n- Si tienes alguna pregunta, por favor contáctanos.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Acerca de"),
        "about_eposides_num": m0,
        "app_name": MessageLookupByLibrary.simpleMessage("Ume"),
        "auto_unlock_next_video": MessageLookupByLibrary.simpleMessage(
            "Desbloqueo automático del siguiente vídeo"),
        "back": MessageLookupByLibrary.simpleMessage("Atrás"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "bonus": MessageLookupByLibrary.simpleMessage("Bonus"),
        "can_be_changed_in_settings": MessageLookupByLibrary.simpleMessage(
            "Se puede cambiar en la configuración"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "check_in": MessageLookupByLibrary.simpleMessage("Registro"),
        "checked_in": MessageLookupByLibrary.simpleMessage("Registrado"),
        "claim": MessageLookupByLibrary.simpleMessage("Reclamar"),
        "coins": MessageLookupByLibrary.simpleMessage("Monedas"),
        "coins_all_supper": MessageLookupByLibrary.simpleMessage("MONEDAS"),
        "coins_num": m1,
        "consumption": MessageLookupByLibrary.simpleMessage("Consumo"),
        "contact_us": MessageLookupByLibrary.simpleMessage("Contáctenos"),
        "daily_check_in":
            MessageLookupByLibrary.simpleMessage("Check-in diario"),
        "daily_check_in_des0": MessageLookupByLibrary.simpleMessage(
            "¡Has estado registrado durante"),
        "daily_check_in_des2":
            MessageLookupByLibrary.simpleMessage("días seguidos!"),
        "daily_tasks": MessageLookupByLibrary.simpleMessage("Tareas Diarias"),
        "day": MessageLookupByLibrary.simpleMessage("Día"),
        "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "delete_account_confirm": m2,
        "delete_account_desc": m3,
        "delete_account_success": MessageLookupByLibrary.simpleMessage(
            "Exitoso, se procesará completamente dentro de 15 días"),
        "done": MessageLookupByLibrary.simpleMessage("Terminado"),
        "earn_rewards":
            MessageLookupByLibrary.simpleMessage("Ganar Recompensas"),
        "empty_list_hint":
            MessageLookupByLibrary.simpleMessage("Esta vacio aqui"),
        "empty_page": MessageLookupByLibrary.simpleMessage("Página vacía"),
        "empty_refresh_prompt": MessageLookupByLibrary.simpleMessage(
            "Algo anda mal, toca para actualizar"),
        "enjoy_all_dramas_for_free": MessageLookupByLibrary.simpleMessage(
            "Disfruta de todos los dramas gratis"),
        "error_toast": MessageLookupByLibrary.simpleMessage(
            "Error, inténtelo de nuevo más tarde"),
        "error_try_again_later": MessageLookupByLibrary.simpleMessage(
            "Algo está mal, inténtalo de nuevo más tarde"),
        "expires_in": MessageLookupByLibrary.simpleMessage("Caduca en"),
        "free_watch": MessageLookupByLibrary.simpleMessage("Ver Gratis"),
        "give_up": MessageLookupByLibrary.simpleMessage("Renunciar"),
        "go": MessageLookupByLibrary.simpleMessage("Ir"),
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "income": MessageLookupByLibrary.simpleMessage("Ingreso"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "log_out": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "log_out_check_msg": MessageLookupByLibrary.simpleMessage(
            "¿Está seguro de que desea cerrar sesión?"),
        "login_app": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "login_success":
            MessageLookupByLibrary.simpleMessage("Inicio de sesión exitoso"),
        "miss_out_stories_prompt": MessageLookupByLibrary.simpleMessage(
            "No te pierdas las historias intermedias."),
        "mobisen_pro": MessageLookupByLibrary.simpleMessage("Ume Pro"),
        "month": MessageLookupByLibrary.simpleMessage("mes"),
        "monthly_pro": MessageLookupByLibrary.simpleMessage("Mensual Pro"),
        "my_bonus": MessageLookupByLibrary.simpleMessage("Mi bonus"),
        "my_coins": MessageLookupByLibrary.simpleMessage("Mis Monedas"),
        "my_list": MessageLookupByLibrary.simpleMessage("Mi lista"),
        "my_wallet": MessageLookupByLibrary.simpleMessage("Mi billetera"),
        "network_error": MessageLookupByLibrary.simpleMessage("Error de red"),
        "new_user_product_give_up_msg": m4,
        "new_user_product_msg": MessageLookupByLibrary.simpleMessage(
            "Exclusivamente para nuevos usuarios. Por tiempo limitado"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notificaciones"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "phone_login_not_supported": MessageLookupByLibrary.simpleMessage(
            "El inicio de sesión por teléfono aún no está disponible"),
        "popular": MessageLookupByLibrary.simpleMessage("Popular"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Política de privacidad"),
        "profile": MessageLookupByLibrary.simpleMessage("Perfil"),
        "purchase_successful":
            MessageLookupByLibrary.simpleMessage("Compra realizada con éxito"),
        "purchase_tips": m5,
        "redirect": MessageLookupByLibrary.simpleMessage("Redirigir"),
        "rewards": MessageLookupByLibrary.simpleMessage("Recompensas"),
        "series": MessageLookupByLibrary.simpleMessage("Serie"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "share": MessageLookupByLibrary.simpleMessage("Compartir"),
        "share_app": MessageLookupByLibrary.simpleMessage("Compartir"),
        "share_app_msg": MessageLookupByLibrary.simpleMessage(
            "Ume: Increíbles dramas cortos te esperan. ¡Empieza a verlos ya!"),
        "sign_in": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "sign_in_email_conflict_prompt": MessageLookupByLibrary.simpleMessage(
            "Ya existe una cuenta con este correo electrónico pero con diferente proveedor"),
        "sign_in_error":
            MessageLookupByLibrary.simpleMessage("Error al iniciar sesión"),
        "sign_in_policy_hint": MessageLookupByLibrary.simpleMessage(
            "Si continúas, aceptas nuestra"),
        "sign_in_with":
            MessageLookupByLibrary.simpleMessage("Iniciar sesión con"),
        "tasks": MessageLookupByLibrary.simpleMessage("Tareas"),
        "terms_of_service":
            MessageLookupByLibrary.simpleMessage("Términos de servicio"),
        "this_episode": MessageLookupByLibrary.simpleMessage("Este episodio"),
        "top_up": MessageLookupByLibrary.simpleMessage("Completar"),
        "try_again_later": MessageLookupByLibrary.simpleMessage(
            "Por favor, inténtelo de nuevo más tarde"),
        "unlock_all_series":
            MessageLookupByLibrary.simpleMessage("Desbloquea todas las series"),
        "unlock_btn": MessageLookupByLibrary.simpleMessage("Desbloquear ahora"),
        "unlock_episode":
            MessageLookupByLibrary.simpleMessage("Desbloquear episodio"),
        "vip_all_supper": MessageLookupByLibrary.simpleMessage("VIP"),
        "watch_ad": MessageLookupByLibrary.simpleMessage("Ver publicidad"),
        "watch_episode": MessageLookupByLibrary.simpleMessage("Ver episodio"),
        "watch_history": MessageLookupByLibrary.simpleMessage("Ver historial"),
        "watch_history_clear_check_msg": MessageLookupByLibrary.simpleMessage(
            "¿Estás seguro de que quieres borrar el historial de reproducciones?"),
        "watch_stories": MessageLookupByLibrary.simpleMessage("Ver historias"),
        "week": MessageLookupByLibrary.simpleMessage("semana"),
        "weekly_pro": MessageLookupByLibrary.simpleMessage("Semanal Pro"),
        "year": MessageLookupByLibrary.simpleMessage("año"),
        "yearly_pro": MessageLookupByLibrary.simpleMessage("Anual Pro")
      };
}
