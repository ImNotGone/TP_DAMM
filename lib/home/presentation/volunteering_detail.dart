import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/components/vacancies.dart';
import '../../shared/molecules/buttons/filled.dart';
import '../domain/volunteering.dart';

class VolunteeringDetail extends HookConsumerWidget {
  final String volunteeringId;

  const VolunteeringDetail({
    super.key,
    required this.volunteeringId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // find the volunteering that has volunteeringId
    final volunteering = ref.read(volunteeringsNotifierProvider)?.firstWhere(
          (volunteering) => volunteering.uid == volunteeringId,
        );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: volunteering != null
          ? _buildContent(context, volunteering)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildContent(BuildContext context, Volunteering volunteering) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              volunteering.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Title and Type
          Text(
            volunteering.type.localizedName(context),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          Text(
            volunteering.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            volunteering.purpose,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // Activity Details
          Text(
            AppLocalizations.of(context)!.activityDetailsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            volunteering.activityDetail,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // Location
          Text(
            AppLocalizations.of(context)!.location,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildLocation(context, volunteering),

          const SizedBox(height: 16),

          // Participation Info
          _buildParticipationInfo(context, volunteering),

          // Apply Button
          const SizedBox(height: 16),
          UtilFilledButton(
            onPressed: () {
              // Handle apply logic
            },
            text: AppLocalizations.of(context)!.applyForVolunteering,
          )
        ],
      ),
    );
  }

  // TODO: this should be in the shared card with blue header!!
  Widget _buildLocation(BuildContext context, Volunteering volunteering) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFCAE5FB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.location,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // TODO: insert map, now dummy
        Image.network(
          'https://staticmapmaker.com/img/google-placeholder.png',
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 8),
        Text(volunteering.address),
      ],
    );
  }

  Widget _buildParticipationInfo(
      BuildContext context, Volunteering volunteering) {
    final requirementsList = volunteering.requirements.split('  ');
    final formattedRequirements = requirementsList.join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.participateInVolunteering,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        // Requirements is markdown text

        MarkdownBody(
          data: formattedRequirements,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          softLineBreak: true,
        ),


        const SizedBox(height: 8),

        // Vacancy Info
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Vacancies(count: volunteering.vacancies),
          ],
        ),      ],
    );
  }
}
