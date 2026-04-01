import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
// import 'package:uuid/v4.dart';

// import '../models/job.dart';
import '../models/org_visit_info.dart';
import '../services/pb_helper.dart';
// import '../services/scheduler.dart';
import '../services/wa_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // ignore: avoid_print
  print('''
[TIME] : ${DateTime.now()}
[METHOD] : ${context.request.method}
[HEADERS] : ${context.request.headers}
[BODY] : ${await context.request.body()}
----------------------------------------
''');
  if (context.request.method == HttpMethod.post) {
    return _handlePostRequest(context);
  } else {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: {'message': 'Method Not Allowed.'},
    );
  }
}

Future<Response> _handlePostRequest(RequestContext context) async {
  // const uuid = UuidV4();
  try {
    // parse body to visitData (visit_id, org_id, create / update)
    final orgVisitInfo = OrgVisitInfo.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );
    //fetch organization expanded details from base pb
    final _org =
        await PbHelper(pbDataUrl: '').fetchOrganization(orgVisitInfo.org_id);
    //fetch visit expanded details from data pb
    final _visit = await PbHelper(pbDataUrl: _org.pb_endpoint)
        .fetchVisit(orgVisitInfo.visit_id);
    //if create =>
    await WaService(
      phone: '2${_visit.patient.phone}',
      message: switch (orgVisitInfo.type) {
        NotificationType.create => _visit.toWaNewVisitInstant(),
        NotificationType.update => _visit.toWaUpdateVisitInstant(),
        NotificationType.invalid => '',
      },
    ).sendTextMessage();
    //if update =>

    // final _job = Job(
    //   locationName: 'Africa/Cairo',
    //   id: uuid.generate(),
    //   callback: () {
    //     //schedule the whatsapp message to be 3 hours before visit time
    //     WaService(
    //       phone: '2${_visit.patient.phone}',
    //       message: switch (orgVisitInfo.type) {
    //         NotificationType.create => _visit.toWaNewVisit(),
    //         NotificationType.update => _visit.toWaUpdateVisit(),
    //         NotificationType.invalid => '',
    //       },
    //     ).sendTextMessage();
    //   },
    //   exec: _visit.visit_date.subtract(
    //     const Duration(hours: 3),
    //   ),
    // );
    // Scheduler().schedule(_job);
    // return response to client

    return Response.json(
      body: {
        'code': 000,
        'message': 'success',
      },
    );
    // ignore: unused_catch_stack
  } catch (e, s) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'message': e.toString(),
        'code': 001,
      },
    );
  }
}
