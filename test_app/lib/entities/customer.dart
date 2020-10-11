class Customer {
  int index;
  String year;
  String industry;
  String loanStatus;
  String paidUpCapital;
  String loanAmount;
  String loanTenure;

  Customer(
      {this.index,
      this.year,
      this.industry,
      this.loanStatus,
      this.paidUpCapital,
      this.loanAmount,
      this.loanTenure});

  Customer.fromJson(Map<dynamic, dynamic> json) {
    Customer(
      year: json['Year of Incorporated'],
      industry: json['Industry'],
      loanStatus: json['Loan Status'],
      paidUpCapital: json['Paid-up Capital'],
      loanAmount: json['Loan Amount'],
      loanTenure: json['Loan Tenure'],
    );
  }
}
