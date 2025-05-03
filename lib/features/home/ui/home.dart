import 'package:bloc_demo/export.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: _listener,
      builder: _builder,
    );
  }

  void _listener(BuildContext context, HomeState state) {
    if (state is HomeActionState) {
      if (state is HomeNavigateToCartPageActionState) {
        _navigateToPage(context, Cart());
      } else if (state is HomeNavigateToWishlistPageActionState) {
        _navigateToPage(context, Wishlist());
      } else if (state is HomeProductItemCartedActionState) {
        _showSnackBar(context, 'Item Carted');
      } else if (state is HomeProductItemWishlistedActionState) {
        _showSnackBar(context, 'Item Wishlisted');
      }
    }
  }

  Widget _builder(BuildContext context, HomeState state) {
    if (state is HomeLoadingState) {
      return _loadingState();
    } else if (state is HomeLoadedSuccessState) {
      return _loadedSuccessState(state);
    } else if (state is HomeErrorState) {
      return _errorState();
    }
    return SizedBox();
  }

  Widget _loadingState() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _loadedSuccessState(HomeLoadedSuccessState state) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Akshit Grocery App'),
        actions: _appBarActions(),
      ),
      body: ListView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          return ProductTileWidget(
            homeBloc: homeBloc,
            productDataModel: state.products[index],
          );
        },
      ),
    );
  }

  List<Widget> _appBarActions() {
    return [
      IconButton(
        onPressed: () => homeBloc.add(HomeWishlistButtonNavigateEvent()),
        icon: Icon(Icons.favorite_border),
      ),
      IconButton(
        onPressed: () => homeBloc.add(HomeCartButtonNavigateEvent()),
        icon: Icon(Icons.shopping_bag_outlined),
      ),
    ];
  }

  Widget _errorState() {
    return Scaffold(body: Center(child: Text('Error')));
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
