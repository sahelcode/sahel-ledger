import 'package:drift/drift.dart';

import '../../domain/ledger/ledger_types.dart';
import 'database.dart';

class SeedCategory {
  const SeedCategory(this.id, this.en, this.bn, this.icon);
  final String id;
  final String en;
  final String bn;
  final String icon;
}

const incomeCategories = [
  SeedCategory('cat.inc.salary', 'Salary', 'বেতন', 'work'),
  SeedCategory('cat.inc.business', 'Business income', 'ব্যবসার আয়', 'store'),
  SeedCategory(
    'cat.inc.family_support',
    'Family support',
    'পারিবারিক সহায়তা',
    'family',
  ),
  SeedCategory('cat.inc.gift', 'Gift received', 'উপহার প্রাপ্তি', 'gift'),
  SeedCategory(
    'cat.inc.education_support',
    'Education support',
    'শিক্ষা সহায়তা',
    'school',
  ),
  SeedCategory('cat.inc.profit', 'Profit / interest', 'মুনাফা / সুদ', 'trend'),
  SeedCategory('cat.inc.other', 'Other income', 'অন্যান্য আয়', 'more'),
];

const expenseCategories = [
  SeedCategory('cat.exp.food', 'Food & groceries', 'খাবার ও বাজার', 'food'),
  SeedCategory('cat.exp.rent', 'Rent', 'বাসা ভাড়া', 'home'),
  SeedCategory(
    'cat.exp.utilities',
    'Electricity, gas, water',
    'বিদ্যুৎ, গ্যাস, পানি',
    'bolt',
  ),
  SeedCategory('cat.exp.transport', 'Transport', 'যাতায়াত', 'bus'),
  SeedCategory('cat.exp.education', 'Education', 'শিক্ষা', 'school'),
  SeedCategory('cat.exp.health', 'Health & medicine', 'চিকিৎসা', 'health'),
  SeedCategory(
    'cat.exp.mobile',
    'Mobile & internet',
    'মোবাইল ও ইন্টারনেট',
    'phone',
  ),
  SeedCategory('cat.exp.clothing', 'Clothing', 'পোশাক', 'shirt'),
  SeedCategory('cat.exp.family', 'Family expenses', 'পারিবারিক খরচ', 'family'),
  SeedCategory('cat.exp.charity', 'Charity / zakat', 'দান / যাকাত', 'heart'),
  SeedCategory('cat.exp.gifts', 'Gifts given', 'উপহার প্রদান', 'gift'),
  SeedCategory(
    SystemAccounts.transferFees,
    'Bank & transfer charges',
    'ব্যাংক ও লেনদেন চার্জ',
    'bank',
  ),
  SeedCategory('cat.exp.other', 'Other expenses', 'অন্যান্য ব্যয়', 'more'),
];

const _systemNames = {
  SystemAccounts.loansReceivable: (
    'Loans given (receivable)',
    'প্রদত্ত ঋণ (পাওনা)',
  ),
  SystemAccounts.advancesReceivable: (
    'Advances to reimburse',
    'অগ্রিম / ফেরতযোগ্য খরচ',
  ),
  SystemAccounts.loansPayable: ('Loans taken (payable)', 'গৃহীত ঋণ (দেনা)'),
  SystemAccounts.fundCapital: ('Fund deposits', 'তহবিল জমা'),
  SystemAccounts.openingBalance: ('Opening balance', 'প্রারম্ভিক জের'),
  SystemAccounts.interFundDue: ('Inter-fund dues', 'তহবিলের মধ্যে পাওনা/দেনা'),
  SystemAccounts.externalSavings: (
    'External samity savings',
    'বাইরের সমিতিতে সঞ্চয়',
  ),
  SystemAccounts.reconciliationDifference: (
    'Reconciliation difference',
    'মিলকরণ পার্থক্য',
  ),
};

Future<void> seedSystemData(AppDatabase db) async {
  final now = DateTime.now();
  await db.batch((b) {
    var order = 0;
    for (final e in SystemAccounts.all.entries) {
      final names = _systemNames[e.key]!;
      b.insert(
        db.ledgerAccounts,
        LedgerAccountsCompanion.insert(
          id: e.key,
          kind: LedgerAccountKind.system,
          accountClass: e.value,
          name: names.$1,
          nameBn: Value(names.$2),
          isSystem: const Value(true),
          sortOrder: Value(order++),
          createdAt: now,
          updatedAt: now,
          syncStatus: const Value(SyncStatus.localOnly),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
    for (final (list, kind, cls) in [
      (incomeCategories, LedgerAccountKind.incomeCategory, AccountClass.income),
      (
        expenseCategories,
        LedgerAccountKind.expenseCategory,
        AccountClass.expense,
      ),
    ]) {
      var i = 0;
      for (final c in list) {
        b.insert(
          db.ledgerAccounts,
          LedgerAccountsCompanion.insert(
            id: c.id,
            kind: kind,
            accountClass: cls,
            name: c.en,
            nameBn: Value(c.bn),
            icon: Value(c.icon),
            isSystem: const Value(true),
            sortOrder: Value(i++),
            createdAt: now,
            updatedAt: now,
            syncStatus: const Value(SyncStatus.localOnly),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    }
  });
}
