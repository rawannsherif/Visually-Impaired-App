class Category {
  Category({
    this.title = '',
    this.imagePath = '',
    this.description = '',
  });

  String title;
  String description;

  String imagePath;

  static List<Category> ImageList = <Category>[
    Category(
      imagePath: 'assets/design_course/1.jpeg',
      description: 'Art and Music \nin the Humanities',
    ),
    Category(
      imagePath: 'assets/design_course/2.jpeg',
      description: 'Anne Frank \nThe diary of\n a young girl',
    ),
    Category(
      imagePath: 'assets/design_course/3.jpeg',
      description: 'John Hamamura\n Color of \nthe sea\n a novel',
    ),
    Category(
      imagePath: 'assets/design_course/4.jpeg',
      description: 'Paulo coelho \nThe spy',
    ),
  ];
}
