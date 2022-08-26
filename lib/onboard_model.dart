class OnboardingContent{
  String image;
  String title;
  String description;

  OnboardingContent({required this.image,required this.title,required this.description});
}

List<OnboardingContent> contents=[
  OnboardingContent(
    title:"Create",
    image: 'images/portfolio.jpg',
    description: "A perfect life resume for yourself",
  ),
  OnboardingContent(
    title:"Record",
    image: 'images/record.jpg',
    description: "All your life accomplishments at one place",
  ),
  OnboardingContent(
    title:"Organize",
    image: 'images/organize.jpg',
    description: "All your life milestones in order",
  ),

];