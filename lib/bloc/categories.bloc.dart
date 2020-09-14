import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/data/models/category.dart';
import 'package:foodie/data/repositories/categories.repository.dart';
import 'package:rxdart/subjects.dart';

class CategoriesBloc extends BaseBloc {
  //CategoryRepository instance
  CategoryRepository _categoryRepository = CategoryRepository();

  //BehaviorSubjects
  BehaviorSubject<List<Category>> _categories =
      BehaviorSubject<List<Category>>();

  //BehaviorSubject stream getters
  Stream<List<Category>> get categories => _categories.stream;

  @override
  void initBloc() async {
    super.initBloc();

    //get the vendors
    fetchCategories();
  }

  //get all categories
  void fetchCategories() async {
    //add null data so listener can show shimmer widget to indicate loading
    _categories.add(null);

    try {
      final categories = await _categoryRepository.getCategories();
      _categories.add(categories);
    } catch (error) {
      print("Error getting categories ==> $error");
    }
  }
}
