import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../model/auth_failure.dart';

/// Banner text for an [AuthFailure]: our copy for known cases, otherwise the
/// server's message.
String authFailureText(BuildContext context, AuthFailure failure) => switch (failure) {
      AuthInvalidCredentials() => 'auth.invalid_credentials'.tr(context: context),
      AuthSessionExpired() => 'auth.sessionExpired'.tr(context: context),
      AuthResetCodeInvalid() => 'auth.reset.codeInvalid'.tr(context: context),
      AuthNetwork() => 'shell.offline'.tr(context: context),
      AuthBlocked(:final message) ||
      AuthEmailInUse(:final message) ||
      AuthValidation(:final message) ||
      AuthUnknown(:final message) =>
        message.isEmpty ? 'common.error'.tr(context: context) : message,
    };
