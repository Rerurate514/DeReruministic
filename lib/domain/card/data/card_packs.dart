import 'package:dereruministic/domain/card/entities/card_definition.dart';

import 'basic_pack.dart';
import 'command_pack.dart';
import 'firewall_pack.dart';
import 'kernel_pack.dart';
import 'restore_pack.dart';
import 'virus_pack.dart';

export 'basic_pack.dart';
export 'command_pack.dart';
export 'firewall_pack.dart';
export 'kernel_pack.dart';
export 'restore_pack.dart';
export 'virus_pack.dart';

/// パック識別子。ドロップテーブルやショップの抽選対象に使う想定。
enum CardPackTypes {
  basic,
  command,
  virus,
  firewall,
  restore,
  kernel,
}

/// パック種別 -> 収録カード定義。
const Map<CardPackTypes, List<CardDefinition>> cardPacks = {
  CardPackTypes.basic: basicPack,
  CardPackTypes.command: commandPack,
  CardPackTypes.virus: virusPack,
  CardPackTypes.firewall: firewallPack,
  CardPackTypes.restore: restorePack,
  CardPackTypes.kernel: kernelPack,
};

/// 全カード定義のフラットなリスト。IDからの逆引きなどに。
const List<CardDefinition> allCardDefinitions = [
  ...basicPack,
  ...commandPack,
  ...virusPack,
  ...firewallPack,
  ...restorePack,
  ...kernelPack,
];
