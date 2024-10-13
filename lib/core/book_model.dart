class BookModel {
  int? textbookId;
  String? textbookTitle;
  String? textbookSubject;
  int? textbookGrade;
  String? textbookDescription;
  String? textbookIsbn;
  String? textbookImageUrl;
  int? providerId;
  String? providerName;
  int? regionId;
  String? regionName;
  String? textbookCreatedAt;
  String? textbookUpdatedAt;

  BookModel(
      {this.textbookId,
        this.textbookTitle,
        this.textbookSubject,
        this.textbookGrade,
        this.textbookDescription,
        this.textbookIsbn,
        this.textbookImageUrl,
        this.providerId,
        this.providerName,
        this.regionId,
        this.regionName,
        this.textbookCreatedAt,
        this.textbookUpdatedAt});

  BookModel.fromJson(Map<String, dynamic> json) {
    textbookId = json['textbook_id'];
    textbookTitle = json['textbook_title'];
    textbookSubject = json['textbook_subject'];
    textbookGrade = json['textbook_grade'];
    textbookDescription = json['textbook_description'];
    textbookIsbn = json['textbook_isbn'];
    textbookImageUrl = json['textbook_image_url'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    regionId = json['region_id'];
    regionName = json['region_name'];
    textbookCreatedAt = json['textbook_created_at'];
    textbookUpdatedAt = json['textbook_updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textbook_id'] = this.textbookId;
    data['textbook_title'] = this.textbookTitle;
    data['textbook_subject'] = this.textbookSubject;
    data['textbook_grade'] = this.textbookGrade;
    data['textbook_description'] = this.textbookDescription;
    data['textbook_isbn'] = this.textbookIsbn;
    data['textbook_image_url'] = this.textbookImageUrl;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['region_id'] = this.regionId;
    data['region_name'] = this.regionName;
    data['textbook_created_at'] = this.textbookCreatedAt;
    data['textbook_updated_at'] = this.textbookUpdatedAt;
    return data;
  }
}
