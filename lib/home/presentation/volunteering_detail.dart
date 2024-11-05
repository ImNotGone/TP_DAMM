import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/home/presentation/info_card.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0x00FFFFFF),
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
    return Expanded(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  // TODO: revisar altura y shadow de esto
                  ClipRRect(
                    child: Image.network(
                      volunteering.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity, // Make it full width
                      height: 200.0, // Set a fixed height for the image
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TIPO Y TITULO
                        const SizedBox(height: 24),
                        Text(
                          volunteering.type.localizedName(context).toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          volunteering.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          volunteering.purpose,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF0D47A1)),
                        ),


                        // ABOUT
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context)!.activityDetailsTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          volunteering.activityDetail,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        // TARJETA
                        const SizedBox(height: 24),
                        _buildLocation(context, volunteering),

                        // INFO DE PARTICIPACION
                        const SizedBox(height: 24),
                        _buildParticipationInfo(context, volunteering),

                        // Apply Button
                        const SizedBox(height: 24),
                        UtilFilledButton(
                          onPressed: () {
                            // Handle apply logic
                          },
                          text: AppLocalizations.of(context)!.applyForVolunteering,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildLocation(BuildContext context, Volunteering volunteering) {
    return CustomCard(
      title: AppLocalizations.of(context)!.location,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: Image.network(
              // TODO: revisar el height
              //height: 155,
              'https://staticmapmaker.com/img/google-placeholder.png',
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!.address.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall
                  ),
                  Text(
                      volunteering.address,
                      style: Theme.of(context).textTheme.bodyLarge
                  ),
                ],
            )
          )
        ],
      ),
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
          style: Theme.of(context).textTheme.headlineMedium,
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
