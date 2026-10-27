import 'package:flutter/widgets.dart';

import '../core/money/money.dart';
import '../domain/ledger/ledger_types.dart';
import '../data/repositories/reports_repository.dart';

/// Bengali-first UI strings. Every string has both languages at the same
/// call site, so a missing translation is a compile error, not a runtime gap.
class S {
  const S(this.bn);

  final bool bn;

  static S of(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'bn'
      ? const S(true)
      : const S(false);

  String _(String en, String bnText) => bn ? bnText : en;

  /// Formats money with the digits of the current language.
  String money(int poisha, {bool signed = false, bool compact = false}) =>
      formatPoisha(
        poisha,
        bengaliDigits: bn,
        signed: signed,
        compactDecimals: compact,
      );

  String num(Object n) => bn ? toBengaliDigits('$n') : '$n';

  String day(int dateKey) {
    final d = DateKey.toDate(dateKey);
    final m = bn ? _monthsBn[d.month - 1] : _monthsEn[d.month - 1];
    return bn ? '${num(d.day)} $m ${num(d.year)}' : '${d.day} $m ${d.year}';
  }

  String month(int monthKey) {
    final m = monthKey % 100;
    final y = monthKey ~/ 100;
    return bn
        ? '${_monthsBnFull[m - 1]} ${num(y)}'
        : '${_monthsEnFull[m - 1]} $y';
  }

  static const _monthsEn = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _monthsEnFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December', //
  ];
  static const _monthsBn = [
    'জানু',
    'ফেব্রু',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টে',
    'অক্টো',
    'নভে',
    'ডিসে',
  ];
  static const _monthsBnFull = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর', //
  ];

  // ----------------------------------------------------------------- brand
  String get appName => _('Sahel Ledger', 'সাহেল লেজার');
  String get tagline =>
      _('Every Taka, Accounted For.', 'প্রতিটি টাকার নির্ভুল হিসাব।');

  // ---------------------------------------------------------------- common
  String get save => _('Save', 'সংরক্ষণ');
  String get saveDraft => _('Save draft', 'খসড়া রাখুন');
  String get cancel => _('Cancel', 'বাতিল');
  String get confirm => _('Confirm', 'নিশ্চিত করুন');
  String get continueLabel => _('Continue', 'এগিয়ে যান');
  String get back => _('Back', 'পেছনে');
  String get close => _('Close', 'বন্ধ');
  String get edit => _('Edit', 'সম্পাদনা');
  String get delete => _('Delete', 'মুছুন');
  String get add => _('Add', 'যোগ করুন');
  String get search => _('Search', 'খুঁজুন');
  String get all => _('All', 'সব');
  String get retry => _('Try again', 'আবার চেষ্টা করুন');
  String get loading => _('Loading…', 'লোড হচ্ছে…');
  String get somethingWrong =>
      _('Something went wrong', 'কিছু একটা সমস্যা হয়েছে');
  String get optional => _('Optional', 'ঐচ্ছিক');
  String get required => _('Required', 'আবশ্যক');
  String get notes => _('Notes', 'নোট');
  String get description => _('Description', 'বিবরণ');
  String get date => _('Date', 'তারিখ');
  String get amount => _('Amount', 'পরিমাণ');
  String get name => _('Name', 'নাম');
  String get phone => _('Phone', 'ফোন');
  String get total => _('Total', 'মোট');
  String get balance => _('Balance', 'জের');
  String get more => _('More', 'আরও');
  String get details => _('Details', 'বিস্তারিত');
  String get seeAll => _('See all', 'সব দেখুন');
  String get done => _('Done', 'সম্পন্ন');
  String get yes => _('Yes', 'হ্যাঁ');
  String get no => _('No', 'না');
  String get advanced => _('More options', 'আরও অপশন');
  String get reference => _('Reference / receipt no.', 'রেফারেন্স / রসিদ নং');
  String get language => _('Language', 'ভাষা');
  String get theme => _('Appearance', 'থিম');
  String get system => _('System', 'সিস্টেম');
  String get light => _('Light', 'লাইট');
  String get dark => _('Dark', 'ডার্ক');
  String get archived => _('Archived', 'আর্কাইভকৃত');
  String get archive => _('Archive', 'আর্কাইভ করুন');
  String get from => _('From', 'থেকে');
  String get to => _('To', 'পর্যন্ত');
  String get debit => _('In', 'জমা');
  String get credit => _('Out', 'খরচ');
  String get opening => _('Opening balance', 'প্রারম্ভিক জের');
  String get closing => _('Closing balance', 'সমাপনী জের');

  // ------------------------------------------------------------ navigation
  String get navHome => _('Home', 'হোম');
  String get navHistory => _('History', 'লেনদেন');
  String get navPeople => _('People', 'ব্যক্তি');
  String get navAccounts => _('Accounts', 'অ্যাকাউন্ট');
  String get navMore => _('More', 'আরও');

  // ------------------------------------------------------------ onboarding
  String get welcomeTitle => _(
    'Your family money, clearly accounted',
    'পরিবারের টাকার পরিষ্কার হিসাব',
  );
  String get welcomeBody => _(
    'Keep track of whose money it is, where it is kept and why it moved — '
        'for yourself and the people who trust you with theirs.',
    'কার টাকা, কোথায় রাখা আছে, কেন খরচ হলো — নিজের এবং যাঁরা আপনার কাছে টাকা রেখেছেন, সবার হিসাব এক জায়গায়।',
  );
  String get onboardPoint1 => _(
    'Separate your own money from money held for others',
    'নিজের টাকা ও অন্যের আমানত আলাদা রাখুন',
  );
  String get onboardPoint2 => _(
    'Works fully offline; syncs when you choose',
    'ইন্টারনেট ছাড়াই চলে; চাইলে সিঙ্ক করুন',
  );
  String get onboardPoint3 => _(
    'Posted entries are never silently changed',
    'পোস্ট করা লেনদেন কখনো গোপনে বদলায় না',
  );
  String get getStarted => _('Get started', 'শুরু করুন');
  String get yourName => _('Your name', 'আপনার নাম');
  String get openingCash => _('Cash in hand now', 'এখন হাতে নগদ কত আছে');
  String get openingCashHint => _(
    'You can add banks and wallets next',
    'পরে ব্যাংক ও মোবাইল ওয়ালেট যোগ করতে পারবেন',
  );
  String get setupTitle => _('Set up your ledger', 'আপনার খাতা প্রস্তুত করুন');
  String get chooseLanguage => _('Choose language', 'ভাষা বেছে নিন');

  // ------------------------------------------------------------- dashboard
  String get greeting => _('Assalamu alaikum', 'আসসালামু আলাইকুম');
  String get totalHeld =>
      _('Total held in all accounts', 'সব অ্যাকাউন্টে মোট টাকা');
  String get yourMoney => _('Your own', 'আপনার নিজের');
  String get heldForOthers => _('Held for others', 'অন্যের আমানত');
  String get personalNetWorth => _('Personal net balance', 'ব্যক্তিগত নিট জের');
  String get personalNetHint => _(
    'Your money in accounts + what others owe you − what you owe',
    'আপনার টাকা + আপনার পাওনা − আপনার দেনা',
  );
  String get owedToYou => _('Owed to you', 'আপনার পাওনা');
  String get youOwe => _('You owe', 'আপনার দেনা');
  String get samitySavings => _('Samity savings', 'সমিতির সঞ্চয়');
  String get thisMonth => _('This month', 'এই মাস');
  String get income => _('Income', 'আয়');
  String get expense => _('Expense', 'ব্যয়');
  String get recent => _('Recent transactions', 'সাম্প্রতিক লেনদেন');
  String get accountsTitle => _('Accounts', 'অ্যাকাউন্টসমূহ');
  String get fundsTitle => _('Funds', 'তহবিল');
  String pendingDrafts(int p, int d) => _(
    '${num(p)} pending · ${num(d)} draft${d == 1 ? '' : 's'} need attention',
    '${num(p)}টি অপেক্ষমাণ · ${num(d)}টি খসড়া মনোযোগ চায়',
  );
  String get notHeldNote => _(
    'Money held for others is shown separately and never counted as yours.',
    'অন্যের আমানত আলাদা দেখানো হয়, আপনার নিজের টাকা হিসেবে গোনা হয় না।',
  );

  // ------------------------------------------------------------------ sync
  String get syncLocalOnly => _('On this device only', 'শুধু এই ডিভাইসে');
  String get syncUpToDate => _('Synced', 'সিঙ্ক সম্পন্ন');
  String syncPending(int n) => _(
    '${num(n)} changes waiting to sync',
    '${num(n)}টি পরিবর্তন সিঙ্কের অপেক্ষায়',
  );
  String get syncNow => _('Sync now', 'এখন সিঙ্ক করুন');
  String get syncFailed =>
      _('Sync failed — will retry', 'সিঙ্ক ব্যর্থ — আবার চেষ্টা করা হবে');
  String get syncConflict =>
      _('Needs your review', 'আপনার পর্যালোচনা প্রয়োজন');
  String get offline => _('Offline', 'অফলাইন');
  String get cloudNotConfigured => _(
    'Cloud sync is not configured in this build. Your data stays on this device.',
    'এই সংস্করণে ক্লাউড সিঙ্ক চালু নেই। আপনার তথ্য এই ডিভাইসেই থাকবে।',
  );

  // ----------------------------------------------------------- transactions
  String get addTransaction => _('Add transaction', 'লেনদেন যোগ করুন');
  String get whatHappened => _('What happened?', 'কী ধরনের লেনদেন?');
  String get account => _('Account', 'অ্যাকাউন্ট');
  String get fromAccount => _('From account', 'যে অ্যাকাউন্ট থেকে');
  String get toAccount => _('To account', 'যে অ্যাকাউন্টে');
  String get whoseMoney => _('Whose money', 'কার টাকা');
  String get toFund => _('Moved to fund', 'যে তহবিলে');
  String get person => _('Person', 'ব্যক্তি');
  String get category => _('Category', 'খাত');
  String get samity => _('Samity', 'সমিতি');
  String get member => _('Member', 'সদস্য');
  String get loan => _('Loan', 'ঋণ');
  String get linkToExisting => _(
    'Link to existing loan / advance',
    'পুরোনো ঋণ/অগ্রিমের সাথে যুক্ত করুন',
  );
  String get newOne => _('New', 'নতুন');
  String get fee => _('Fee / charge', 'চার্জ');
  String get review => _('Review', 'পর্যালোচনা');
  String get reviewTitle =>
      _('Review before posting', 'পোস্ট করার আগে দেখে নিন');
  String get post => _('Post', 'পোস্ট করুন');
  String get markPending => _('Save as pending', 'অপেক্ষমাণ হিসেবে রাখুন');
  String get pendingHint => _(
    'Pending entries (e.g. an uncleared cheque) are not counted in balances until confirmed.',
    'অপেক্ষমাণ লেনদেন (যেমন: চেক ক্লিয়ার হয়নি) নিশ্চিত না হওয়া পর্যন্ত জেরে গোনা হয় না।',
  );
  String get posted => _('Transaction posted', 'লেনদেন পোস্ট হয়েছে');
  String get draftSaved => _(
    'Saved as draft — complete it later',
    'খসড়া সংরক্ষিত — পরে সম্পূর্ণ করুন',
  );
  String get draftWhy => _(
    'Some facts are missing. Post needs them; a draft keeps what you have without affecting balances.',
    'কিছু তথ্য বাকি। পোস্ট করতে সেগুলো লাগবে; খসড়া জেরে প্রভাব না ফেলে তথ্য রেখে দেয়।',
  );
  String get duplicateWarning =>
      _('Possible duplicate', 'সম্ভাব্য দ্বৈত এন্ট্রি');
  String duplicateBody(int n) => _(
    'You already recorded ${num(n)} similar entr${n == 1 ? 'y' : 'ies'} with the same amount and date.',
    'একই পরিমাণ ও তারিখে আগেই ${num(n)}টি একই রকম লেনদেন আছে।',
  );
  String get postAnyway => _('Post anyway', 'তবুও পোস্ট করুন');
  String get reverse => _('Reverse', 'রিভার্স করুন');
  String get reverseAndCorrect =>
      _('Reverse & re-enter', 'রিভার্স করে নতুন এন্ট্রি');
  String get reverseReason =>
      _('Why are you reversing this?', 'কেন রিভার্স করছেন?');
  String get reverseExplain => _(
    'Posted entries are never edited. A reversal adds an opposite entry so history stays complete.',
    'পোস্ট করা লেনদেন সম্পাদনা হয় না। রিভার্স একটি বিপরীত এন্ট্রি যোগ করে, ফলে পুরো ইতিহাস থাকে।',
  );
  String get reversed => _('Reversed', 'রিভার্সকৃত');
  String get reversalOf => _('Reversal of', 'রিভার্স —');
  String get confirmPending => _('Confirm & post', 'নিশ্চিত করে পোস্ট');
  String get cancelPending => _('Cancel entry', 'এন্ট্রি বাতিল');
  String get completeDraft => _('Complete draft', 'খসড়া সম্পূর্ণ করুন');
  String get deleteDraft => _('Delete draft', 'খসড়া মুছুন');
  String get noTransactions => _('No transactions yet', 'এখনও কোনো লেনদেন নেই');
  String get noTransactionsBody =>
      _('Tap + to record your first one.', 'প্রথম লেনদেন যোগ করতে + চাপুন।');
  String get historyTitle => _('Transaction history', 'লেনদেনের ইতিহাস');
  String get filters => _('Filters', 'ফিল্টার');
  String get clearFilters => _('Clear', 'মুছে ফেলুন');
  String get auditTrail => _('Audit trail', 'অডিট ট্রেইল');
  String get lines => _('Ledger lines', 'খতিয়ান লাইন');
  String get attachments => _('Receipts', 'রসিদ');
  String get addReceipt => _('Attach receipt', 'রসিদ যুক্ত করুন');
  String get createdBy => _('Recorded by', 'যিনি লিখেছেন');

  String txType(TxType t) => switch (t) {
    TxType.income => _('Income', 'আয়'),
    TxType.expense => _('Expense', 'ব্যয়'),
    TxType.transfer => _(
      'Transfer between my accounts',
      'নিজের অ্যাকাউন্টে স্থানান্তর',
    ),
    TxType.fundDeposit => _('Deposit for someone', 'কারও আমানত জমা'),
    TxType.fundWithdrawal => _(
      'Return / pay out to owner',
      'আমানত ফেরত / প্রদান',
    ),
    TxType.loanGiven => _('Lend money', 'ধার দিলাম'),
    TxType.loanRepaymentReceived => _('Loan repaid to me', 'ধার ফেরত পেলাম'),
    TxType.loanTaken => _('Borrow money', 'ধার নিলাম'),
    TxType.loanRepaymentPaid => _('I repaid a loan', 'ধার শোধ করলাম'),
    TxType.advancePaid => _(
      'Paid on someone\'s behalf',
      'অন্যের হয়ে খরচ করলাম',
    ),
    TxType.reimbursementReceived => _(
      'Reimbursement received',
      'খরচের টাকা ফেরত পেলাম',
    ),
    TxType.samityContribution => _('Samity contribution', 'সমিতির কিস্তি'),
    TxType.samityPayout => _('Samity payout', 'সমিতি থেকে উত্তোলন'),
    TxType.interFundLoan => _(
      'Use one fund for another',
      'এক তহবিলের টাকা অন্য তহবিলে ব্যবহার',
    ),
    TxType.interFundRepayment => _(
      'Return money between funds',
      'তহবিলের টাকা ফেরত',
    ),
    TxType.openingBalance => _('Opening balance', 'প্রারম্ভিক জের'),
    TxType.adjustment => _('Reconciliation adjustment', 'মিলকরণ সমন্বয়'),
    TxType.reversal => _('Reversal', 'রিভার্স'),
  };

  String txTypeHint(TxType t) => switch (t) {
    TxType.income => _(
      'Salary, gift, business income…',
      'বেতন, উপহার, ব্যবসার আয়…',
    ),
    TxType.expense => _('Bazar, rent, bills…', 'বাজার, ভাড়া, বিল…'),
    TxType.transfer => _(
      'Bank → bKash, cash → bank. Not income.',
      'ব্যাংক → বিকাশ, নগদ → ব্যাংক। আয় নয়।',
    ),
    TxType.fundDeposit => _(
      'A sister/relative keeps money with you',
      'বোন/আত্মীয় আপনার কাছে টাকা রাখলেন',
    ),
    TxType.fundWithdrawal => _(
      'Give back money you hold for someone',
      'আমানতের টাকা মালিককে দিলেন',
    ),
    TxType.loanGiven => _('Creates money owed to you', 'আপনার পাওনা তৈরি হয়'),
    TxType.loanRepaymentReceived => _('Reduces what they owe', 'পাওনা কমে'),
    TxType.loanTaken => _('Creates money you owe', 'আপনার দেনা তৈরি হয়'),
    TxType.loanRepaymentPaid => _('Reduces what you owe', 'দেনা কমে'),
    TxType.advancePaid => _('They should pay you back', 'তিনি পরে ফেরত দেবেন'),
    TxType.reimbursementReceived => _('Settles an advance', 'অগ্রিম মিটে যায়'),
    TxType.samityContribution => _(
      'Monthly samity / committee money',
      'মাসিক সমিতি/কমিটির টাকা',
    ),
    TxType.samityPayout => _(
      'Money paid out of a samity',
      'সমিতি থেকে টাকা প্রদান',
    ),
    TxType.interFundLoan => _(
      'Recorded as a due between the funds',
      'তহবিলগুলোর মধ্যে দেনা হিসেবে থাকে',
    ),
    TxType.interFundRepayment => _(
      'Settles a due between funds',
      'তহবিলের দেনা মেটে',
    ),
    TxType.openingBalance => _(
      'Money already there when you started',
      'শুরুর সময় যা ছিল',
    ),
    TxType.adjustment => _(
      'Explained correction after counting',
      'গণনার পর ব্যাখ্যাসহ সংশোধন',
    ),
    TxType.reversal => _(
      'Cancels a posted entry',
      'পোস্ট করা লেনদেন বাতিল করে',
    ),
  };

  String status(TxStatus s) => switch (s) {
    TxStatus.draft => _('Draft', 'খসড়া'),
    TxStatus.staging => _('Saving', 'সংরক্ষণ হচ্ছে'),
    TxStatus.pending => _('Pending', 'অপেক্ষমাণ'),
    TxStatus.posted => _('Posted', 'পোস্টকৃত'),
    TxStatus.cancelled => _('Cancelled', 'বাতিল'),
  };

  String syncStatus(SyncStatus s) => switch (s) {
    SyncStatus.localOnly => _('Local only', 'শুধু ডিভাইসে'),
    SyncStatus.pending => _('Waiting to sync', 'সিঙ্কের অপেক্ষায়'),
    SyncStatus.synced => _('Synced', 'সিঙ্কড'),
    SyncStatus.failed => _('Sync failed', 'সিঙ্ক ব্যর্থ'),
    SyncStatus.conflict => _('Conflict', 'দ্বন্দ্ব'),
  };

  String fieldError(String field, String code) {
    final f = switch (field) {
      'amount' => amount,
      'fromAccount' => fromAccount,
      'toAccount' => toAccount,
      'fund' => whoseMoney,
      'toFund' => toFund,
      'person' => person,
      'category' => category,
      'samity' => samity,
      'obligation' => loan,
      'reason' => _('Reason', 'কারণ'),
      _ => field,
    };
    return switch (code) {
      'required' => _('$f is required', '$f দিতে হবে'),
      'same_account' => _(
        'Choose two different accounts',
        'দুটি ভিন্ন অ্যাকাউন্ট বেছে নিন',
      ),
      'same_fund' => _(
        'Choose two different funds',
        'দুটি ভিন্ন তহবিল বেছে নিন',
      ),
      'personal_fund_not_allowed' => _(
        'Money into your own fund is income — use Income instead',
        'নিজের তহবিলে টাকা আসা মানে আয় — "আয়" ব্যবহার করুন',
      ),
      'wrong_category' => _('Pick a matching category', 'মানানসই খাত বেছে নিন'),
      'mismatch' => _(
        '$f does not match the linked loan',
        '$f যুক্ত ঋণের সাথে মিলছে না',
      ),
      _ => _('$f is not valid', '$f সঠিক নয়'),
    };
  }

  String moneyError(MoneyParseError e) => switch (e) {
    MoneyParseError.empty => _('Enter an amount', 'পরিমাণ লিখুন'),
    MoneyParseError.invalid => _('Enter a valid amount', 'সঠিক পরিমাণ লিখুন'),
    MoneyParseError.negative => _(
      'Amount cannot be negative',
      'পরিমাণ ঋণাত্মক হতে পারে না',
    ),
    MoneyParseError.tooManyDecimals => _(
      'At most 2 decimal places (poisha)',
      'দশমিকের পর সর্বোচ্চ ২ ঘর (পয়সা)',
    ),
    MoneyParseError.tooLarge => _('Amount is too large', 'পরিমাণ অনেক বেশি'),
  };

  // --------------------------------------------------------------- people
  String get peopleTitle => _('People', 'ব্যক্তিগণ');
  String get addPerson => _('Add person', 'ব্যক্তি যোগ করুন');
  String get relation => _('Relation', 'সম্পর্ক');
  String get holdsMoneyWithMe =>
      _('Keeps money with me', 'আমার কাছে টাকা রাখেন');
  String get holdsMoneyHint => _(
    'Creates a separate entrusted fund for this person',
    'এই ব্যক্তির জন্য আলাদা আমানত তহবিল তৈরি হবে',
  );
  String get heldForPerson => _('Held for them', 'তাঁর আমানত');
  String get theyOweYou => _('They owe you', 'তাঁর কাছে পাওনা');
  String get youOweThem => _('You owe them', 'তাঁর কাছে দেনা');
  String get netPosition => _('Net position', 'নিট অবস্থান');
  String get noPeople => _('No people yet', 'এখনও কেউ নেই');
  String get noPeopleBody => _(
    'Add sisters, relatives or friends whose money you hold, lend or borrow.',
    'যাঁদের টাকা রাখেন, ধার দেন বা নেন — বোন, আত্মীয়, বন্ধু যোগ করুন।',
  );
  String get me => _('Me', 'আমি');
  String get statement => _('Statement', 'বিবরণী');
  String get dues => _('Loans & advances', 'ঋণ ও অগ্রিম');

  String relationLabel(String r) => switch (r) {
    'self' => me,
    'sister' => _('Sister', 'বোন'),
    'brother' => _('Brother', 'ভাই'),
    'mother' => _('Mother', 'মা'),
    'father' => _('Father', 'বাবা'),
    'uncle' => _('Uncle', 'চাচা/মামা'),
    'aunt' => _('Aunt', 'চাচি/খালা'),
    'relative' => _('Relative', 'আত্মীয়'),
    'friend' => _('Friend', 'বন্ধু'),
    'colleague' => _('Colleague', 'সহকর্মী'),
    'business' => _('Business', 'ব্যবসা'),
    _ => _('Other', 'অন্যান্য'),
  };
  static const relations = [
    'sister',
    'brother',
    'mother',
    'father',
    'uncle',
    'aunt',
    'relative',
    'friend',
    'colleague',
    'business',
    'other', //
  ];

  // --------------------------------------------------------------- funds
  String fundKind(FundKind k) => switch (k) {
    FundKind.personal => _('Personal', 'ব্যক্তিগত'),
    FundKind.entrusted => _('Entrusted', 'আমানত'),
    FundKind.purpose => _('Purpose fund', 'উদ্দেশ্যভিত্তিক'),
    FundKind.samity => _('Samity pool', 'সমিতি তহবিল'),
  };
  String fundName(String name, FundKind kind) =>
      kind == FundKind.personal ? _('My money', 'আমার নিজের টাকা') : name;
  String get addFund => _('Add fund', 'তহবিল যোগ করুন');
  String get fundOwner => _('Owner', 'মালিক');
  String get purposeExample =>
      _('e.g. Uncle — education support', 'যেমন: মামা — পড়াশোনার খরচ');
  String get overdrawnFund => _(
    'This fund spent more than it holds here',
    'এই তহবিল এখানে যা আছে তার বেশি খরচ করেছে',
  );

  // ------------------------------------------------------------- accounts
  String get addAccount => _('Add account', 'অ্যাকাউন্ট যোগ করুন');
  String get accountType => _('Type', 'ধরন');
  String get institution => _('Bank / provider', 'ব্যাংক / প্রতিষ্ঠান');
  String get lastDigits =>
      _('Last 4 digits (optional)', 'শেষ ৪ সংখ্যা (ঐচ্ছিক)');
  String get lastDigitsHint => _(
    'Never enter the full account number',
    'পুরো অ্যাকাউন্ট নম্বর দেবেন না',
  );
  String get currentBalance => _('Current balance', 'বর্তমান জের');
  String get whoOwnsThis => _('Who owns the money in it', 'এতে কার কত টাকা');
  String storageType(StorageType t) => switch (t) {
    StorageType.cash => _('Cash', 'নগদ'),
    StorageType.bank => _('Bank', 'ব্যাংক'),
    StorageType.mobileWallet => _('Mobile wallet', 'মোবাইল ওয়ালেট'),
    StorageType.other => _('Other', 'অন্যান্য'),
  };
  String get noAccounts => _('No accounts', 'কোনো অ্যাকাউন্ট নেই');

  // --------------------------------------------------------- obligations
  String get loansTitle => _('Loans & advances', 'ঋণ ও অগ্রিম');
  String get lent => _('Lent', 'ধার দেওয়া');
  String get borrowed => _('Borrowed', 'ধার নেওয়া');
  String get advances => _('Advances', 'অগ্রিম');
  String get outstanding => _('Outstanding', 'বকেয়া');
  String get principal => _('Principal', 'মূল');
  String get settled => _('Settled', 'পরিশোধিত');
  String get open => _('Open', 'চলমান');
  String get dueDate => _('Due date', 'পরিশোধের তারিখ');
  String get recordRepayment => _('Record repayment', 'পরিশোধ লিখুন');
  String get overpaid =>
      _('Repaid more than lent', 'যা দেওয়া হয়েছিল তার বেশি ফেরত');
  String get noLoans => _('No loans or advances', 'কোনো ঋণ বা অগ্রিম নেই');

  // ---------------------------------------------------------------- samity
  String get samityTitle => _('Savings & samity', 'সঞ্চয় ও সমিতি');
  String get addSamity => _('Add samity', 'সমিতি যোগ করুন');
  String get samityManaged =>
      _('I hold the money (treasurer)', 'টাকা আমার কাছে থাকে (কোষাধ্যক্ষ)');
  String get samityExternal =>
      _('I am a member elsewhere', 'আমি অন্য সমিতির সদস্য');
  String get contribution => _('Contribution per period', 'প্রতি কিস্তি');
  String get monthly => _('Monthly', 'মাসিক');
  String get weekly => _('Weekly', 'সাপ্তাহিক');
  String get startDate => _('Start date', 'শুরুর তারিখ');
  String get members => _('Members', 'সদস্যগণ');
  String get paid => _('Paid', 'পরিশোধ');
  String get expected => _('Expected', 'প্রত্যাশিত');
  String get due => _('Due', 'বাকি');
  String get noSamity => _('No samity yet', 'এখনও কোনো সমিতি নেই');

  // --------------------------------------------------------------- budgets
  String get budgets => _('Monthly budgets', 'মাসিক বাজেট');
  String get setBudget => _('Set budget', 'বাজেট নির্ধারণ');
  String get spent => _('Spent', 'খরচ');
  String get limit => _('Limit', 'সীমা');

  // --------------------------------------------------------- reconciliation
  String get reconTitle => _('Reconciliation', 'মিলকরণ');
  String get reconIntro => _(
    'Count the real balance of an account and compare it with the ledger. '
        'Differences are never corrected automatically.',
    'অ্যাকাউন্টের আসল টাকা গুনে খাতার সাথে মেলান। পার্থক্য কখনো স্বয়ংক্রিয়ভাবে ঠিক করা হয় না।',
  );
  String get countedBalance =>
      _('Counted / statement balance', 'গণনা / স্টেটমেন্ট অনুযায়ী জের');
  String get ledgerBalance => _('Ledger balance', 'খাতার জের');
  String get difference => _('Difference', 'পার্থক্য');
  String get startRecon => _('Compare', 'মিলিয়ে দেখুন');
  String get matched => _('Matched', 'মিলেছে');
  String get unresolved => _('Unresolved', 'অমীমাংসিত');
  String get pendingApproval => _('Awaiting approval', 'অনুমোদনের অপেক্ষায়');
  String get adjusted => _('Adjusted', 'সমন্বিত');
  String get recordAdjustment =>
      _('Record explained adjustment', 'ব্যাখ্যাসহ সমন্বয় করুন');
  String get adjustmentReason =>
      _('What explains the difference?', 'পার্থক্যের কারণ কী?');
  String get approve => _('Approve', 'অনুমোদন');
  String get reject => _('Reject', 'প্রত্যাখ্যান');
  String get possibleCauses => _('Possible causes', 'সম্ভাব্য কারণ');
  List<String> get causes => [
    _(
      'An entry not recorded yet (check drafts)',
      'কোনো লেনদেন লেখা বাকি (খসড়া দেখুন)',
    ),
    _(
      'A pending entry that already cleared',
      'অপেক্ষমাণ লেনদেন যা আসলে সম্পন্ন',
    ),
    _('Bank / bKash charges not entered', 'ব্যাংক / বিকাশ চার্জ লেখা হয়নি'),
    _('Money recorded in the wrong account', 'ভুল অ্যাকাউন্টে লেখা হয়েছে'),
    _('A duplicate entry', 'দ্বৈত এন্ট্রি'),
  ];
  String get healthChecks => _('Health checks', 'স্বাস্থ্য পরীক্ষা');
  String get allClear => _('No problems found', 'কোনো সমস্যা পাওয়া যায়নি');

  String diagnostic(DiagnosticKind k) => switch (k) {
    DiagnosticKind.unbalancedTransaction => _(
      'Unbalanced entry',
      'ভারসাম্যহীন এন্ট্রি',
    ),
    DiagnosticKind.negativeStorage => _(
      'Account balance below zero',
      'অ্যাকাউন্টের জের শূন্যের নিচে',
    ),
    DiagnosticKind.fundOverdrawnInAccount => _(
      'A fund is using money that is not its own',
      'একটি তহবিল অন্যের টাকা ব্যবহার করছে',
    ),
    DiagnosticKind.overpaidObligation => _(
      'Repaid more than owed',
      'দেনার চেয়ে বেশি পরিশোধ',
    ),
    DiagnosticKind.staleDraft => _(
      'Draft older than a week',
      'এক সপ্তাহের পুরোনো খসড়া',
    ),
    DiagnosticKind.possibleDuplicate => _(
      'Possible duplicate',
      'সম্ভাব্য দ্বৈত এন্ট্রি',
    ),
    DiagnosticKind.unusualAmount => _(
      'Unusually large amount',
      'অস্বাভাবিক বড় পরিমাণ',
    ),
    DiagnosticKind.unresolvedReconciliation => _(
      'Unresolved reconciliation',
      'অমীমাংসিত মিলকরণ',
    ),
    DiagnosticKind.syncConflict => _('Sync conflict', 'সিঙ্ক দ্বন্দ্ব'),
    DiagnosticKind.auditChainBroken => _(
      'Audit log tampered',
      'অডিট লগে হস্তক্ষেপ',
    ),
  };

  // --------------------------------------------------------------- reports
  String get reportsTitle => _('Reports & PDF', 'রিপোর্ট ও পিডিএফ');
  String get generatePdf => _('Create PDF', 'পিডিএফ তৈরি করুন');
  String get pdfWarning => _(
    'A PDF is a copy. Once shared it cannot be recalled — share only with people who should see it.',
    'পিডিএফ একটি কপি। একবার শেয়ার করলে আর ফেরত নেওয়া যায় না — শুধু যাঁদের দেখা উচিত তাঁদের দিন।',
  );
  String get period => _('Period', 'সময়কাল');
  String get reportLanguage => _('Report language', 'রিপোর্টের ভাষা');
  String get reportPerson => _('Person statement', 'ব্যক্তির পূর্ণ বিবরণী');
  String get reportFund => _('Fund statement', 'তহবিল বিবরণী');
  String get reportAccount => _('Account statement', 'অ্যাকাউন্ট বিবরণী');
  String get reportRange => _('Transactions in a period', 'সময়ভিত্তিক লেনদেন');
  String get reportMonthly => _('Monthly income & expense', 'মাসিক আয়-ব্যয়');
  String get reportLoans => _('Loans & repayments', 'ঋণ ও পরিশোধ');
  String get reportAdvances => _('Advances & reimbursements', 'অগ্রিম ও ফেরত');
  String get reportSamity => _('Samity savings', 'সমিতির সঞ্চয়');
  String get reportSummary =>
      _('Household financial summary', 'পারিবারিক আর্থিক সারসংক্ষেপ');
  String get reportRecon =>
      _('Reconciliation & discrepancies', 'মিলকরণ ও অসঙ্গতি');
  String get choose => _('Choose', 'বেছে নিন');

  // ------------------------------------------------------------- household
  String get householdTitle => _('Household & members', 'পরিবার ও সদস্য');
  String get signIn => _('Sign in', 'সাইন ইন');
  String get signOut => _('Sign out', 'সাইন আউট');
  String get createAccount => _('Create account', 'অ্যাকাউন্ট খুলুন');
  String get email => _('Email', 'ইমেইল');
  String get password => _('Password', 'পাসওয়ার্ড');
  String get forgotPassword => _('Forgot password?', 'পাসওয়ার্ড ভুলে গেছেন?');
  String get resetSent =>
      _('Password reset email sent', 'পাসওয়ার্ড রিসেট ইমেইল পাঠানো হয়েছে');
  String get verifyEmail => _(
    'Verify your email to join or invite members',
    'সদস্য যোগ বা আমন্ত্রণে ইমেইল যাচাই করুন',
  );
  String get sendVerification =>
      _('Send verification email', 'যাচাই ইমেইল পাঠান');
  String get createHousehold => _('Create household', 'পরিবার তৈরি করুন');
  String get joinHousehold =>
      _('Join with invite code', 'আমন্ত্রণ কোড দিয়ে যোগ দিন');
  String get inviteCode => _('Invite code', 'আমন্ত্রণ কোড');
  String get inviteMember => _('Invite member', 'সদস্যকে আমন্ত্রণ');
  String get role => _('Role', 'ভূমিকা');
  String get owner => _('Owner', 'মালিক');
  String get admin => _('Administrator', 'প্রশাসক');
  String get memberRole => _('Member', 'সদস্য');
  String get canSeeFunds =>
      _('Can see these funds', 'এই তহবিলগুলো দেখতে পারবেন');
  String get revoke => _('Revoke access', 'অ্যাক্সেস বাতিল');
  String get inviteCreated => _(
    'Share this code. It works once, for 7 days, for that email only.',
    'কোডটি শেয়ার করুন। শুধু ওই ইমেইলে, একবার, ৭ দিনের জন্য কাজ করবে।',
  );
  String get roleOwnerHint => _('Full control', 'পূর্ণ নিয়ন্ত্রণ');
  String get roleAdminHint =>
      _('Only the permissions you delegate', 'শুধু আপনার দেওয়া অনুমতি');
  String get roleMemberHint =>
      _('Read-only, only chosen funds', 'শুধু দেখতে পারবেন, নির্দিষ্ট তহবিল');
  String get accountRecovery => _(
    'Account recovery: reset your password by email. Keep a local backup too — it restores everything even without the cloud.',
    'অ্যাকাউন্ট পুনরুদ্ধার: ইমেইলে পাসওয়ার্ড রিসেট করুন। লোকাল ব্যাকআপও রাখুন — ক্লাউড ছাড়াই সব ফিরিয়ে আনা যায়।',
  );

  // -------------------------------------------------------------- settings
  String get settingsTitle => _('Settings', 'সেটিংস');
  String get backupTitle => _('Backup & restore', 'ব্যাকআপ ও পুনরুদ্ধার');
  String get createBackup => _('Create backup file', 'ব্যাকআপ ফাইল তৈরি');
  String get restoreBackup =>
      _('Restore from backup', 'ব্যাকআপ থেকে ফিরিয়ে আনুন');
  String get restoreWarning => _(
    'Restoring replaces everything on this device with the backup. A safety backup of the current data is made first.',
    'পুনরুদ্ধার করলে এই ডিভাইসের সব তথ্য ব্যাকআপ দিয়ে প্রতিস্থাপিত হবে। আগে বর্তমান তথ্যের একটি নিরাপত্তা ব্যাকআপ নেওয়া হবে।',
  );
  String get backupDone =>
      _('Backup created and verified', 'ব্যাকআপ তৈরি ও যাচাই হয়েছে');
  String get restoreDone =>
      _('Restore complete and verified', 'পুনরুদ্ধার সম্পন্ন ও যাচাই হয়েছে');
  String lastBackup(String when) =>
      _('Last backup: $when', 'শেষ ব্যাকআপ: $when');
  String get never => _('never', 'কখনো না');
  String get syncTitle => _('Cloud sync', 'ক্লাউড সিঙ্ক');
  String get categories => _('Categories', 'খাতসমূহ');
  String get about => _('About', 'সম্পর্কে');
  String get integrity => _('Data integrity', 'তথ্যের অখণ্ডতা');
  String get auditOk => _(
    'Audit log verified — no tampering',
    'অডিট লগ যাচাইকৃত — কোনো হস্তক্ষেপ নেই',
  );
  String auditBroken(int seq) => _(
    'Audit log broken at event ${num(seq)}',
    'অডিট লগ ${num(seq)} নম্বর ঘটনায় ভাঙা',
  );
}
