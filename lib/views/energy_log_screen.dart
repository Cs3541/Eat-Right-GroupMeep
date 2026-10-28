import 'package:flutter/material.dart';
import '../presenters/energy_log_presenter.dart';

class EnergyLogScreen extends StatefulWidget {
  const EnergyLogScreen({super.key});

  @override
  State<EnergyLogScreen> createState() => _EnergyLogScreenState();
}

class _EnergyLogScreenState extends State<EnergyLogScreen> {
  final EnergyLogPresenter _presenter = EnergyLogPresenter();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _presenter.loadEnergyLogs();
    setState(() {
      _isLoading = 
    })
  }
}