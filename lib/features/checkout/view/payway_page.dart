import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/platform/link_opener.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/error_banner.dart';
import '../controller/payway_bloc.dart';
import '../model/payway.dart';

/// PayWay's KHQR checkout page in an in-app web view. With ABA Mobile installed the
/// page may hand off to it; otherwise the customer stays on the QR. Pops with a
/// [PaywayOutcome] once the payment settles, the customer leaves, or the hold ends.
class PaywayPage extends StatefulWidget {
  const PaywayPage({super.key});

  @override
  State<PaywayPage> createState() => _PaywayPageState();
}

class _PaywayPageState extends State<PaywayPage> with WidgetsBindingObserver {
  late final WebViewController _controller;
  late final PaywayBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PaywayBloc>();
    final launch = _bloc.state.launch;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onNavigationRequest: _onNavigation))
      ..loadRequest(Uri.parse(launch.session.checkoutUrl));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back from ABA Mobile (return_deeplink) or any app switch: ask right away.
    if (state == AppLifecycleState.resumed) _bloc.add(const PaywayResumed());
  }

  NavigationDecision _onNavigation(NavigationRequest request) {
    final launch = _bloc.state.launch;
    final decision = decidePaywayNavigation(
      request.url,
      session: launch.session,
      canOpenAba: launch.canOpenAba,
      isMainFrame: request.isMainFrame,
    );
    switch (decision) {
      case PaywayNavigation.allow:
        return NavigationDecision.navigate;
      case PaywayNavigation.openApp:
        openAppLink(request.url);
        return NavigationDecision.prevent;
      case PaywayNavigation.returned:
        _bloc.add(const PaywayResumed());
        return NavigationDecision.prevent;
      case PaywayNavigation.block:
        return NavigationDecision.prevent;
    }
  }

  Future<void> _confirmClose() async {
    if (_bloc.state.closing || _bloc.state.outcome != null) return;
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const Key('pay.closeDialog'),
        content: Text('pay.closeConfirm'.tr(context: dialogContext)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('pay.stay'.tr(context: dialogContext)),
          ),
          FilledButton(
            key: const Key('pay.leave'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('pay.leave'.tr(context: dialogContext)),
          ),
        ],
      ),
    );
    if (leave == true) _bloc.add(const PaywayCloseRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaywayBloc, PaywayState>(
      listenWhen: (previous, current) => previous.outcome == null && current.outcome != null,
      listener: (context, state) => Navigator.of(context).pop(state.outcome),
      builder: (context, state) => PopScope<PaywayOutcome>(
        canPop: state.outcome != null,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmClose();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('pay.title'.tr(context: context)),
            leading: IconButton(
              key: const Key('pay.close'),
              icon: const Icon(Icons.close),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: state.closing ? null : _confirmClose,
            ),
          ),
          body: Column(
            children: [
              if (state.message != null)
                ErrorBanner(
                  message: state.message!.isEmpty ? 'shell.offline'.tr(context: context) : state.message!,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x1),
                child: Row(
                  children: [
                    const SizedBox.square(dimension: Space.x2, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: Space.x1),
                    Text('pay.checking'.tr(context: context), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (state.closing) const LinearProgressIndicator(),
              Expanded(child: WebViewWidget(controller: _controller)),
            ],
          ),
        ),
      ),
    );
  }
}
