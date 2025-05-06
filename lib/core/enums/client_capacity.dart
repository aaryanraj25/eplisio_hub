enum ClientCapacity {
  END_USER('end_user', 'End User'),
  INTENT_PROVIDER('intent_provider', 'Intent Provider'),
  DECISION_MAKER('decision_maker', 'Decision Maker'),
  INFLUENCER('influencer', 'Influencer'),
  PURCHASE('purchase', 'Purchase'),
  STORE_NAME('store_name', 'Store Name');

  final String value;
  final String displayName;
  
  const ClientCapacity(this.value, this.displayName);
  
  static ClientCapacity fromString(String value) {
    return ClientCapacity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ClientCapacity.END_USER,
    );
  }
}