Features
Signup and Login with Switch User Option
We have implemented user authentication with signup and login functionalities. Additionally, we have included a feature that allows users to switch between different accounts, similar to Gmail's multiple account management.

Background Location Data Collection and ListView Display
Our app captures the user's location in the background at intervals of every 15 minutes. We utilize Realm, a database solution, to securely store this location data. The stored location data is displayed in a list format within the app, with each list item providing concise location descriptions.

Custom Info Window on Google Map View
We have integrated Google Maps into the app to provide a visual representation of geographical locations. Upon selecting an item from the list, a customized information window is shown on the Google Map at the corresponding location. This window offers detailed insights about the selected location.

Playback Button for Animated Location History
We have enhanced the Google Map view with a "Playback" button. When activated, this button animates the historical movement of the user's tracked locations over time. This historical data is retrieved and visualized from the Realm database, providing an engaging user experience.
