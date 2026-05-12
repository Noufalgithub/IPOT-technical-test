// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get seeMenu => '查看菜单';

  @override
  String get scanQrToOrder => '扫描二维码点餐';

  @override
  String get positionQr => '将二维码放入框内即可扫描';

  @override
  String get needCameraPermission => '我们需要相机权限来扫描二维码';

  @override
  String get cameraError => '相机错误';

  @override
  String get or => '或';

  @override
  String get enterTableId => '输入桌号';

  @override
  String get submit => '提交';

  @override
  String get tableId => '桌号';

  @override
  String get enterTableIdDescription => '请输入您的桌号以查看菜单';

  @override
  String get exampleTableId => '示例：T001';

  @override
  String get emptyTableIdError => '请先输入桌号';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get pointCameraToQr => '将相机对准桌面二维码';

  @override
  String get qrAvailableOnTable => '二维码位于您的桌面上';

  @override
  String get manualInputTableId => '手动输入桌号';

  @override
  String get invalidQrCode => '无效的二维码。请重新扫描。';

  @override
  String get outOfStock => '售罄';

  @override
  String get viewCart => '查看购物车';

  @override
  String failedCreateOrder(String message) {
    return '创建订单失败：$message';
  }

  @override
  String get cart => '购物车';

  @override
  String itemCount(int count) {
    return '$count 件商品';
  }

  @override
  String get clearAll => '全部清除';

  @override
  String get emptyCart => '购物车为空';

  @override
  String get addFavoriteMenu => '添加您最喜欢的菜单！';

  @override
  String get viewMenu => '查看菜单';

  @override
  String get kitchenNoteHint => '给厨房的备注（可选）...\n例如：不加洋葱，不要辣';

  @override
  String subtotal(int count) {
    return '小计 ($count 件商品)';
  }

  @override
  String get total => '总计';

  @override
  String get processingOrder => '正在处理订单...';

  @override
  String get orderNow => '立即下单';

  @override
  String get clearCartTitle => '清空购物车';

  @override
  String get clearCartContent => '确定要清空购物车吗？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get note => '备注';

  @override
  String get orderSuccessTitle => '订单成功！';

  @override
  String get orderSuccessMessage => '您的订单正在厨房处理中';

  @override
  String get orderId => '订单号';

  @override
  String get statusWaiting => '等待中';

  @override
  String get estimatedTime => '预计时间';

  @override
  String get trackOrder => '追踪订单';

  @override
  String get orderMore => '再来一单';

  @override
  String get liveUpdate => '实时更新';

  @override
  String get orderStatus => '订单状态';

  @override
  String get orderDetail => '订单详情';

  @override
  String get orderCompleted => '订单已完成';

  @override
  String get statusPending => '等待中';

  @override
  String get statusConfirmed => '已确认';

  @override
  String get statusPreparing => '准备中';

  @override
  String get statusReady => '已准备好';

  @override
  String get statusServed => '已上菜';

  @override
  String get statusCancelled => '已取消';

  @override
  String get descPending => '您的订单正在等待收银员确认';

  @override
  String get descConfirmed => '您的订单已确认！';

  @override
  String get descPreparing => '厨房正在准备您的订单...';

  @override
  String get descReady => '您的订单已准备就绪！即将上菜';

  @override
  String get descServed => '祝您用餐愉快！';

  @override
  String get loadingMenu => '正在加载菜单...';

  @override
  String get failedLoadMenu => '加载菜单失败';

  @override
  String get tryAgain => '重试';

  @override
  String get menu => '菜单';

  @override
  String get noMenuFound => '未找到菜单';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get add => '添加';

  @override
  String get pleaseSelectAllRequired => '请选择所有必选项';

  @override
  String addedToCart(String itemName) {
    return '已将 $itemName 添加到购物车';
  }

  @override
  String get optional => '可选';

  @override
  String get required => '必选';

  @override
  String get chooseOption => '单选';

  @override
  String get chooseMultiple => '多选';

  @override
  String get addToCart => '加入购物车';

  @override
  String get updateItem => '更新';

  @override
  String get searchMenu => '搜索菜单...';

  @override
  String get addNote => '添加备注 (选填)';

  @override
  String get checkout => '去结账';

  @override
  String get remove => '移除';

  @override
  String table(String id) {
    return '$id 号桌';
  }

  @override
  String get tableLabel => '桌号';

  @override
  String get free => '免费';

  @override
  String get digitalOrdering => '数字化点餐';

  @override
  String get errorNetwork => '网络连接问题，请检查您的网络。';

  @override
  String get errorServer => '服务器目前不可用，请稍后再试。';

  @override
  String get errorTimeout => '请求超时，请重试。';

  @override
  String get errorUnknown => '发生了意外错误。';

  @override
  String get errorHandshake => '安全连接失败，请检查您的网络设置。';

  @override
  String mins(int time) {
    return '$time 分钟';
  }
}
