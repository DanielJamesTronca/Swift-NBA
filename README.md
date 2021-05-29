# GENERAL NOTES 📝
Le API fornite da [link](https://rapidapi.com/theapiguy/api/free-nba/endpoints) non offrono la possibilità di ottenere i giocatori di una specifica squadra.
Per risolvere il problema è stato implementato un layer di caching non appena viene avviata l'applicazione. Questo effettua un loop su circa 25 pagine (a scopi di test ed onde evitare eccessivi caricamenti è stato inserito questo "numero magico") e salva i dati con CoreData.
Una volta effettuato ciò, risulta piu semplice attraverso UITableViewDiffableDataSource filtrare i giocatori per team.

# ARCHITECTURE NOTES 📝
Sono stati implementati dei protocol (repository) che forniscono i dati al ViewModel. Questo non "tocca" mai la rete o il database in maniera diretta. Questo approccio facilita i test potendo creare dei FakeRepository.
Durante i test non viene mai chiamato il Server i dati devono essere sempre gli stessi e con una chiamata network non si puo sapere l'esito.

# NOTABLE FEATURES 🚀
- Dark mode
- Unit Tests
- Core data
- Error management
- Clean architecture for testing, with network layer and protocols to retrieve data
- Organized project structure
- Beautiful UI
- Localization
- Loading screen and empty screen management
- Table view, UITableViewDiffableDataSource, and UI both with programmatic and storyboard-based approach
