import 'package:flutter/material.dart';

class SearchUserScreen extends StatelessWidget {
  const SearchUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search User'),
      ),
      body: Center(
        child: SearchAnchor(
          builder: (context, searchController) {
            return SearchBar(
              controller: searchController,
              hintText: "Search User",
              onTap: () {
                searchController.openView();
              },
              onChanged: (_) {
                searchController.openView();
              },
            );
          },
          suggestionsBuilder: (context, searchController) {
            return List<ListTile>.generate(5, (index) {
              return ListTile(
                title: Text('User $index'),
                onTap: () {
                  searchController.closeView('User 50');
                  // searchController.text = 'User $index';
                },
              );
            });
          },
        ),
      ),
    );
  }
}
