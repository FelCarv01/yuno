import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:localization/localization.dart';
import 'package:yuno/app/core/widgets/searchable_dropdown.dart';
import 'package:yuno/app/interactor/models/embeds/player.dart';

import '../../../core/constants/retroarch_cores.dart';
import '../../../interactor/atoms/app_atom.dart';
import '../../../interactor/models/app_model.dart';

class PlayerSelect extends StatelessWidget {
  final Player? player;
  final void Function(Player? player) onChanged;

  const PlayerSelect({
    super.key,
    this.player,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AppModel>(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'player_app'.i18n(),
              ),
              value: player?.app,
              selectedItemBuilder: (BuildContext context) {
                return appsState.value.map((AppModel value) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundImage: MemoryImage(
                          value.icon,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        value.name.substring(
                          0,
                          min(value.name.length, 30),
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
              onChanged: (AppModel? newValue) {
                if (newValue != null) {
                  onChanged(
                    player?.copyWith(app: newValue) ?? Player(app: newValue),
                  );
                }
              },
              items: appsState.value.map((AppModel value) {
                return DropdownMenuItem<AppModel>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 9,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: MemoryImage(
                            value.icon,
                          ),
                        ),
                        const Gap(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              value.name.substring(
                                0,
                                min(value.name.length, 30),
                              ),
                            ),
                            Text(
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                              value.package.substring(
                                0,
                                min(value.package.length, 30),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (player?.app.package.startsWith('com.retroarch') == true)
              const Gap(17),
            if (player?.app.package.startsWith('com.retroarch') == true)
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: SearchableDropdown(
                      onSearchTextChanged: (newValue) {
                        if (newValue != null) {
                          onChanged(player?.copyWith(extra: newValue));
                        }
                      },
                      label: 'retroarch_cores'.i18n(),
                      item: player?.extra,
                      items: retroarchCores,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('retroarch_cores'.i18n()),
                            content: Text(
                              'retroarch_cores_content'.i18n(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('ok'.i18n()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                  )
                ],
              ),
          ],
        ),
      ],
    );
  }
}
