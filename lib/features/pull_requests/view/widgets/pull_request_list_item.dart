import 'package:flutter/material.dart';
import 'package:github_pr_explorer/features/pull_requests/data/models/pull_request_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PullRequestListItem extends StatelessWidget {
  final PullRequestModel pullRequest;

  const PullRequestListItem({super.key, required this.pullRequest});

  Widget buildStatusChip(PullRequestDisplayStatus status) {
    Color borderColor;

    switch (status) {
      case PullRequestDisplayStatus.open:
        borderColor = Colors.green;
        break;
      case PullRequestDisplayStatus.draft:
        borderColor = Colors.grey;
        break;
      case PullRequestDisplayStatus.merged:
        borderColor = Colors.purple;
        break;
      case PullRequestDisplayStatus.closed:
        borderColor = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        status.name.toUpperCase(), // or keep 'Open' etc. as before
        style: TextStyle(color: borderColor, fontSize: 10, height: 1),
      ),
      backgroundColor: Colors.transparent, // no fill'
      labelPadding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: -4,
      ), // tighter control
      padding: EdgeInsets.zero, // less padding
      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap, // removes min size
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // same as Chip default
        side: BorderSide(color: borderColor, width: 0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.go('/pull-requests/detail', extra: pullRequest);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Wrap the Text widget with Expanded
                    child: Text(
                      pullRequest.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  buildStatusChip(pullRequest.prStatus),
                ],
              ),

              const SizedBox(height: 8.0),
              Text(
                (pullRequest.body != null && pullRequest.body!.isNotEmpty)
                    ? pullRequest.body!
                    : 'No description provided.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12, height: 1.2),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'by ${pullRequest.user.login}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    formatter.format(pullRequest.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
