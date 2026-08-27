import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/card/data/command_pack.dart';
import 'package:dereruministic/domain/card/data/firewall_pack.dart';
import 'package:dereruministic/domain/card/data/glitch_pack.dart';
import 'package:dereruministic/domain/card/data/kernel_pack.dart';
import 'package:dereruministic/domain/card/data/overload_pack.dart';
import 'package:dereruministic/domain/card/data/payload_pack.dart';
import 'package:dereruministic/domain/card/data/restore_pack.dart';
import 'package:dereruministic/domain/card/data/stealth_pack.dart';
import 'package:dereruministic/domain/card/data/virus_pack.dart';
import 'package:dereruministic/domain/card/entities/card_definition.dart';

export 'basic_pack.dart';
export 'command_pack.dart';
export 'firewall_pack.dart';
export 'glitch_pack.dart';
export 'kernel_pack.dart';
export 'overload_pack.dart';
export 'payload_pack.dart';
export 'restore_pack.dart';
export 'stealth_pack.dart';
export 'virus_pack.dart';

/// パック識別子。ドロップテーブルやショップの抽選対象に使う想定。
enum CardPackTypes {
  basic,
  command,
  virus,
  firewall,
  restore,
  kernel,
  overload,
  glitch,
  stealth,
  payload,
}

/// パック種別 -> 収録カード定義。
const Map<CardPackTypes, List<CardDefinition>> cardPacks = {
  CardPackTypes.basic: basicPack,
  CardPackTypes.command: commandPack,
  CardPackTypes.virus: virusPack,
  CardPackTypes.firewall: firewallPack,
  CardPackTypes.restore: restorePack,
  CardPackTypes.kernel: kernelPack,
  CardPackTypes.overload: overloadPack,
  CardPackTypes.glitch: glitchPack,
  CardPackTypes.stealth: stealthPack,
  CardPackTypes.payload: payloadPack,
};

/// 全カード定義のフラットなリスト。IDからの逆引きなどに。
const List<CardDefinition> allCardDefinitions = [
  ...basicPack,
  ...commandPack,
  ...virusPack,
  ...firewallPack,
  ...restorePack,
  ...kernelPack,
  ...overloadPack,
  ...glitchPack,
  ...stealthPack,
  ...payloadPack,
];
