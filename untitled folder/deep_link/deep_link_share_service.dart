import 'package:qixer/midas_misr/core/deep_link/deep_link_router.dart';
import 'package:share_plus/share_plus.dart';

class DeepLinkShareService {
  DeepLinkShareService._();

  static Future<void> shareServiceDetails({
    required int serviceId,
    int? providerId,
  }) {
    final link = DeepLinkRouter.buildServiceDetailsLink(
      serviceId: serviceId,
      providerId: providerId,
    );
    return SharePlus.instance.share(ShareParams(text: link.toString()));
  }

  static Future<void> shareStayServiceDetails({
    int? serviceId,
    required StayMode mode,
  }) {
    final link = DeepLinkRouter.buildStayServiceDetailsLink(
      serviceId: serviceId,
      mode: mode,
    );
    return SharePlus.instance.share(ShareParams(text: link.toString()));
  }
}
