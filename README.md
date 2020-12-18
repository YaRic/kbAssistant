# kbAssistant

The kbAssistant / KB-Assi should help kickbase user. Currently the project ist completely in german language because kickbase just support the german "Bundesliga". The project was developed by Yannik Richter (yannik.richter@googlemail.com). The project is based on fluter. Current features are:

## "+- Rechner" / +- Calculator
A calculator that should give the customer support by organizing their balances to a positive number (otherwise you are not getting points for the upcoming matchday. 

![](./README_assets/example_PMRechner.png)

The user can select the player to sell and sell them directly afterwards by swiping the "verkaufen" SwipeButton.

![](./README_assets/example_Sell1.png)

After accept with "Bestätigen" the player will be sold automatically and the page refreshes with the new budget and the existing players.

![](./README_assets/example_Sell2.png)

## "Zahlliste" / Payment List
Background: In our league we decided to make the last three of each matchday pay an small amount that we collect until end of the season. After the last matchday we use this money to have a nice evening.

The "Zahlliste" gives an overview about the current standings of payment. In parallel you can get an short explanation to that feature, copy the list to the clipboard or configure the prices for each placement. 
![](./README_assets/example_paymentlist1.png) ![](./README_assets/example_paymentlist2.png) ![](./README_assets/example_paymentlist3.png)

Example for copy to clipboard output:
Zahlliste 12. Spieltag:

Malte Jordan: 42,00 €
Konstey: 29,00 €
Tobi : 18,00 €
Yannik Richter: 18,00 €
Seto Keicha: 13,00 €
Steekmozaiek: 8,00 €
Luis Figo: 7,00 €
Sandro Di Porzio: 6,00 €
ValentinS10: 3,00 €


## "Marktwersteigerung" / Marketvalue Increasement
In the "Marktwertsteigerung" section the user can get an feeling if its transfers were succesfull from a financial point of view:

![](./README_assets/example_MWSteigerung.png)

## Base functionality

### Login
Just use your kickbase mail adress and password.

![](./README_assets/example_login.PNG)

### Change league
Via the dropdown the user can switch between his leagues.

![](./README_assets/example_switchLeague.PNG)

### Logout

Via the logout button in the top right corner the user can logout.

![](./README_assets/example_logout.PNG)

## Info about Flutter
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
