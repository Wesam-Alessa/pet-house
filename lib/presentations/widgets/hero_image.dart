import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({
    Key? key,
    required this.welcomeImage,
     required this.signin,
  }) : super(key: key);

  final String welcomeImage;
  final bool signin;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(welcomeImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if(signin)Positioned(
          bottom: 14,
          left: 24,
          child: Text(
            AppLocalizations.of(context)!.start_your_journey,
            maxLines: 2,
            style: textTheme.headline4!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 44,
          left: 24,
          child: Row(
            children: [
              const Icon(
                Icons.sunny_snowing,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.petHouse,
                maxLines: 2,
                style: textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
