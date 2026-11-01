import 'package:flutter/material.dart';

void main() {
  runApp(const GlobalStudyApp());
}

class Opportunity {
  final String university;
  final String country;
  final String degree;
  final String field;
  final String funding;
  final String description;

  Opportunity(this.university, this.country, this.degree, this.field,
      this.funding, this.description);
}

final List<Opportunity> opportunities = [
  Opportunity(
    'University of Toronto',
    'Canada',
    'Masters',
    'Computer Science',
    'Partially Funded',
    'Explore graduate study opportunities in computer science.',
  ),
  Opportunity(
    'University of Melbourne',
    'Australia',
    'Masters',
    'Information Technology',
    'Fully Funded',
    'Explore postgraduate study and scholarship opportunities.',
  ),
  Opportunity(
    'University of Oxford',
    'United Kingdom',
    'PhD',
    'Artificial Intelligence',
    'Fully Funded',
    'Explore doctoral research and funding opportunities.',
  ),
  Opportunity(
    'Technical University of Munich',
    'Germany',
    'Masters',
    'Computer Science',
    'Partially Funded',
    'Explore graduate programmes and admission requirements.',
  ),
  Opportunity(
    'Seoul National University',
    'South Korea',
    'PhD',
    'Data Science',
    'Fully Funded',
    'Explore research programmes and scholarship options.',
  ),
];

class GlobalStudyApp extends StatefulWidget {
  const GlobalStudyApp({super.key});

  @override
  State<GlobalStudyApp> createState() => _GlobalStudyAppState();
}

class _GlobalStudyAppState extends State<GlobalStudyApp> {
  int selectedTab = 0;
  final List<Opportunity> saved = [];

  void toggleSave(Opportunity item) {
    setState(() {
      if (saved.contains(item)) {
        saved.remove(item);
      } else {
        saved.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(saved: saved, toggleSave: toggleSave),
      SavedPage(saved: saved, toggleSave: toggleSave),
      const RoadmapPage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Global Study AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: pages[selectedTab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab,
          onDestinationSelected: (index) {
            setState(() => selectedTab = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.route_outlined),
              label: 'Roadmap',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Opportunity> saved;
  final Function(Opportunity) toggleSave;

  const HomePage({
    super.key,
    required this.saved,
    required this.toggleSave,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final results = opportunities.where((item) {
      return '${item.university} ${item.country} ${item.field} ${item.degree}'
          .toLowerCase()
          .contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Global Study AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PreferencesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF176B87),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Future Starts Here!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Discover international study opportunities, '
                  'scholarships and your next academic pathway.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Find Your Study Opportunity',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => search = value),
            decoration: InputDecoration(
              hintText: 'Search country, degree or subject...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Explore Opportunities',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            const Text('No matching opportunities found.')
          else
            ...results.map(
              (item) => OpportunityCard(
                item: item,
                isSaved: widget.saved.contains(item),
                toggleSave: widget.toggleSave,
              ),
            ),
        ],
      ),
    );
  }
}

class OpportunityCard extends StatelessWidget {
  final Opportunity item;
  final bool isSaved;
  final Function(Opportunity) toggleSave;

  const OpportunityCard({
    super.key,
    required this.item,
    required this.isSaved,
    required this.toggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance, color: Color(0xFF176B87)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.university,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => toggleSave(item),
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF176B87),
                  ),
                ),
              ],
            ),
            Text('${item.country} • ${item.degree}'),
            const SizedBox(height: 5),
            Text(item.field),
            const SizedBox(height: 8),
            Chip(
              label: Text(item.funding),
              backgroundColor: const Color(0xFFDDF2E8),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailsPage(
                        item: item,
                        isSaved: isSaved,
                        toggleSave: toggleSave,
                      ),
                    ),
                  );
                },
                child: const Text('View Details →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String country = 'Any Country';
  String degree = 'Masters';
  String field = 'Computer Science';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Your Preferences',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Preferred Country'),
            DropdownButton<String>(
              isExpanded: true,
              value: country,
              items: [
                'Any Country',
                'Canada',
                'Germany',
                'Australia',
                'United Kingdom',
                'South Korea'
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => country = v!),
            ),
            const SizedBox(height: 15),
            const Text('Degree Level'),
            DropdownButton<String>(
              isExpanded: true,
              value: degree,
              items: ['Masters', 'PhD']
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => degree = v!),
            ),
            const SizedBox(height: 15),
            const Text('Preferred Field'),
            DropdownButton<String>(
              isExpanded: true,
              value: field,
              items: [
                'Computer Science',
                'Information Technology',
                'Artificial Intelligence',
                'Data Science'
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => field = v!),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preferences selected!')),
                );
              },
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Opportunity item;
  final bool isSaved;
  final Function(Opportunity) toggleSave;

  const DetailsPage({
    super.key,
    required this.item,
    required this.isSaved,
    required this.toggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opportunity Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Icon(Icons.school, size: 65, color: Color(0xFF176B87)),
            const SizedBox(height: 15),
            Text(
              item.university,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            detail('Country', item.country),
            detail('Degree', item.degree),
            detail('Field', item.field),
            detail('Funding', item.funding),
            detail('Description', item.description),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                toggleSave(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSaved
                          ? 'Removed from saved items'
                          : 'Opportunity saved',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.bookmark),
              label: Text(isSaved ? 'Remove Saved Item' : 'Save Opportunity'),
            ),
          ],
        ),
      ),
    );
  }

  Widget detail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  final List<Opportunity> saved;
  final Function(Opportunity) toggleSave;

  const SavedPage({
    super.key,
    required this.saved,
    required this.toggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Opportunities')),
      body: saved.isEmpty
          ? const Center(child: Text('You have no saved opportunities yet.'))
          : ListView(
              padding: const EdgeInsets.all(15),
              children: saved
                  .map((item) => OpportunityCard(
                        item: item,
                        isSaved: true,
                        toggleSave: toggleSave,
                      ))
                  .toList(),
            ),
    );
  }
}

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  final List<String> tasks = [
    'Research universities',
    'Check admission requirements',
    'Prepare academic documents',
    'Prepare language test',
    'Search for scholarships',
    'Submit applications',
  ];

  final Set<int> completed = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Study Roadmap')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Track Your Progress',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('${completed.length} of ${tasks.length} tasks completed'),
          const SizedBox(height: 15),
          LinearProgressIndicator(value: completed.length / tasks.length),
          const SizedBox(height: 20),
          ...List.generate(
            tasks.length,
            (index) => CheckboxListTile(
              title: Text(tasks[index]),
              value: completed.contains(index),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    completed.add(index);
                  } else {
                    completed.remove(index);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
