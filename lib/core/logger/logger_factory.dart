import 'package:eco_route_mobile_app/core/logger/logger.dart';
import 'package:eco_route_mobile_app/core/logger/stub_logger.dart';
import 'package:eco_route_mobile_app/core/logger/talker_logger.dart';
import 'package:flutter/foundation.dart';

class LoggerFactory {
  static Logger createImplementation() {
    if (kReleaseMode) {
      return StubLogger();
    }

    return LoggerTalkerImpl.getInstance();
  }
}
