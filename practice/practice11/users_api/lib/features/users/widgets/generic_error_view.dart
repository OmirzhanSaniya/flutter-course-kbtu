import 'package:flutter/material.dart';

import 'message_view.dart';

// BadResponseException: we could not read the answer. A bug report,
// not a Retry — so no button.
class GenericErrorView extends StatelessWidget {
  const GenericErrorView({super.key, this.title = 'Something went wrong'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MessageView(icon: Icons.error_outline, title: title);
  }
}
