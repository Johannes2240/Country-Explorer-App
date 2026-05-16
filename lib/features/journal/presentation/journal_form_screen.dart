import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../countries/models/country_model.dart';
import '../bloc/journal_bloc.dart';
import '../bloc/journal_event.dart';
import '../bloc/journal_state.dart';
import '../models/journal_entry_model.dart';

class JournalFormScreen extends StatefulWidget {
  const JournalFormScreen({super.key, this.country, this.entry});

  final CountryModel? country;
  final JournalEntryModel? entry;

  @override
  State<JournalFormScreen> createState() => _JournalFormScreenState();
}

class _JournalFormScreenState extends State<JournalFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _notesController;
  late String _status;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
    _status = widget.entry?.status ?? 'want_to_go';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final existing = widget.entry;
    final country = widget.country;

    final entry = JournalEntryModel(
      id: existing?.id,
      countryCode: existing?.countryCode ?? country?.cca2 ?? '',
      countryName: existing?.countryName ?? country?.commonName ?? '',
      flagUrl: existing?.flagUrl ?? country?.flagUrl,
      status: _status,
      notes: _notesController.text.trim(),
      addedAt: existing?.addedAt ?? DateTime.now(),
      isSynced: existing?.isSynced ?? false,
    );

    if (existing == null) {
      context.read<JournalBloc>().add(AddEntry(entry));
    } else {
      context.read<JournalBloc>().add(UpdateEntry(entry));
    }
    setState(() => _isSubmitting = true);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.entry == null
        ? 'Add Journal Entry'
        : 'Edit Journal Entry';
    final countryName =
        widget.entry?.countryName ??
        widget.country?.commonName ??
        'Destination';

    return BlocListener<JournalBloc, JournalState>(
      listener: (BuildContext context, JournalState state) {
        if (state is JournalSuccess) {
          setState(() => _isSubmitting = false);
          context.go('/journal');
        } else if (state is JournalError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(countryName, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              'Write a reason, memory, or plan that makes this destination personal.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    dropdownColor: AppTheme.kSurface,
                    style: Theme.of(context).textTheme.bodyLarge,
                    iconEnabledColor: AppTheme.kAccent,
                    decoration: const InputDecoration(
                      labelText: 'Travel Status',
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'want_to_go',
                        child: Text('Want to Go'),
                      ),
                      DropdownMenuItem(
                        value: 'planning',
                        child: Text('Planning'),
                      ),
                      DropdownMenuItem(
                        value: 'visited',
                        child: Text('Visited'),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    minLines: 5,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText:
                          'Why do you want to go, or what made the trip memorable?',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Add at least one note';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: Text(
                        _isSubmitting
                            ? 'Saving...'
                            : widget.entry == null
                            ? 'Save to Journal'
                            : 'Update Entry',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
