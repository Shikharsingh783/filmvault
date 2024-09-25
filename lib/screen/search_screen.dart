import 'package:filmvault/components/search_show_card.dart';
import 'package:filmvault/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: TextField(
                controller: searchProvider.searchController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'Search for shows...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => searchProvider
                        .searchShows(searchProvider.searchController.text),
                  ),
                ),
                onChanged:
                    searchProvider.searchShows, // Trigger search on text change
              ),
            ),
            if (searchProvider.isLoading)
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Set the item count for shimmer
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        height: 100,
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 15,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (searchProvider.errorMessage != null)
              Center(
                child: Text(
                  searchProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (searchProvider.searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final show = searchProvider.searchResults[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SearchShowCard(
                          url: show.imageUrlOriginal.toString(),
                          name: show.name,
                          genres: show.genres),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'No results found.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
