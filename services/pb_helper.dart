import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

import '../models/organization.dart';
import '../models/visit.dart';

class PbHelper {
  PbHelper({
    required this.pbDataUrl,
  });

  final String pbDataUrl;

  //TODO:
  static final instance = PocketBase(Platform.environment['BASE_PB_URL'] ?? '');

  late final dataInstance = PocketBase(pbDataUrl);

  Future<OrganizationExpanded> fetchOrganization(String org_id) async {
    final _result = await instance.collection('organizations').getOne(
          org_id,
          expand: 'members',
        );

    return OrganizationExpanded.fromRecordModel(_result);
  }

  Future<VisitExpanded> fetchVisit(String visit_id) async {
    const _expand = 'doc_id, clinic_id, patient_id';
    final _result = await dataInstance.collection('visits').getOne(
          visit_id,
          expand: _expand,
        );

    return VisitExpanded.fromRecordModel(_result);
  }
}
