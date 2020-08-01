import 'package:battery_optimization/battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:NOVID_19/helper/localization.dart';

class BatteryOptimizationsDialog {
    final BuildContext _context;

    BatteryOptimizationsDialog(this._context);

    void _onValueChange(bool state) async {
        await SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('battery_dont_ask', state);
        });
    }

    void displayDialog() async {
        return showDialog(
            context: _context,
            builder: (_) => new AlertDialog(
                title: Text(AppLocalizations.of(_context).translate('BATTERY_DIALOG_TITLE')),
                content: Column(
                    children: [
                        Row(
                            children: [
                                Text(AppLocalizations.of(_context).translate('BATTERY_DIALOG_QUESTION')),
                            ],
                        ),
                        CheckboxListTile(
                            title: Text(AppLocalizations.of(_context).translate('BATTERY_DIALOG_CHECKBOX')),
                            value: false,
                            onChanged: (value) => _onValueChange(value),
                        ),
                    ],
                ),
                actions: <Widget>[
                    FlatButton(
                        child: new Text(AppLocalizations.of(_context).translate('BATTERY_DIALOG_CANCEL')),
                        onPressed: () {
                            Navigator.of(_context).pop();
                        },
                    ),
                    FlatButton(
                        child: new Text(AppLocalizations.of(_context).translate('BATTERY_DIALOG_OK')),
                        onPressed: () {
                            BatteryOptimization.openBatteryOptimizationSettings();
                        },
                    )
                ],
            )
        );
    }
}
