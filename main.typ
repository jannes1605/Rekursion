#import "@preview/supercharged-dhbw:3.4.1": *
#import "acronyms.typ": acronyms
#import "glossary.typ": glossary

#show: supercharged-dhbw.with(
  title: "Rekursion – Konzepte, Strukturen und Umsetzung in funktionalen Programmiersprachen",
  authors: (
    (name: "Emanuel Schuessler", student-id: "???", course: "WI25SEA", course-of-studies: "Wirtschaftsinformatik", company: (
      (name: "SAP SE", post-code: "69190", city: "Walldorf")
    )),
    (name: "Jannes Borgmann", student-id: "???", course: "WI25SEA", course-of-studies: "Wirtschaftsinformatik", company: (
      (name: "SAP SE", post-code: "69190", city: "Walldorf")
    )),
  ),
  acronyms: acronyms,
  at-university: false,
  bibliography: bibliography("sources.bib"),
  date: datetime(year: 2026, month: 5, day: 8),
  supervisor: (university: "Edelbert Schumm"),
  glossary: glossary,
  language: "de",
  university: "Duale Hochschule Baden-Württemberg",
  university-location: "Mannheim",
  university-short: "DHBW",
)

= Einleitung

Rekursion ist eines der grundlegendsten und gleichzeitig faszinierendsten Konzepte der Informatik und Mathematik. Sie beschreibt ein Prinzip, bei dem etwas nicht explizit, sondern durch einfachere Versionen seiner selbst definiert wird @lorenz2012. Was auf den ersten Blick wie ein logischer Zirkel wirkt, erweist sich bei näherer Betrachtung als ein äußerst mächtiges Werkzeug: Viele Probleme, die sich iterativ nur umständlich beschreiben lassen, besitzen eine natürliche, elegante rekursive Formulierung.

Im Alltag begegnet uns Rekursion häufiger, als wir es zunächst vermuten würden. Das Blätterwerk eines Baumes, die Verzweigungen eines Flusssystems oder Schneeflockenmuster folgen rekursiven Bildungsgesetzen. In der Mathematik tritt Rekursion schon in der Schule auf, etwa bei der Definition von Folgen oder bei der Fakultätsfunktion – auch wenn der Begriff selbst dort oft vermieden wird. In der Informatik und insbesondere in der funktionalen Programmierung nimmt Rekursion eine zentrale Rolle ein: Sie ist das primäre Mittel zur Beschreibung von Wiederholungen, da rein funktionale Sprachen wie Haskell auf veränderliche Zustandsvariablen und klassische Schleifen verzichten @pepper2006.

Diese Ausarbeitung beleuchtet zunächst die theoretischen Grundlagen und die Geschichte der Rekursion, erläutert anschließend rekursive Funktionen und rekursive Datenstrukturen und zeigt schließlich deren konkrete Umsetzung in der funktionalen Programmiersprache Haskell. Abschließend werden Querverbindungen zu verwandten Themen wie Listen, Datenstrukturen und dem Lambda-Kalkül hergestellt.

= Definition und Grundlagen der Rekursion

== Was ist Rekursion?

#gls("Rekursion") bezeichnet in der Mathematik und Informatik ein Konstruktionsprinzip, bei dem eine Definition unmittelbar oder mittelbar auf sich selbst verweist. Eine oft zitierte, informelle Beschreibung lautet: _„Man definiert etwas nicht explizit, sondern durch einfachere Versionen seiner selbst"_ @lorenz2012. Entscheidend dabei ist das Wort „einfacher": Damit eine rekursive Definition sinnvoll ist und nicht ins Unendliche führt, muss jeder Selbstaufruf das Problem auf eine kleinere, einfachere Variante zurückführen.

Jede korrekte rekursive Definition besteht daher aus mindestens zwei Bestandteilen. Der erste ist der *#gls("Basisfall")*, auch Verankerung oder Abbruchbedingung genannt. Er beschreibt einen Spezialfall, der sich direkt und ohne weiteren Selbstaufruf lösen lässt. Er stellt sicher, dass die Rekursion irgendwann terminiert. Der zweite Bestandteil ist der *allgemeine Fall*, auch Vererbung genannt. Hier wird das eigentliche Problem auf eine einfachere Version desselben Problems zurückgeführt, indem die Funktion sich selbst mit einem reduzierten Argument aufruft – dem sogenannten #gls("Selbstaufruf"). Das allgemeine Standard-Rekursionsschema lässt sich formal wie folgt darstellen @lorenz2012:

$ f(x) = cases(
  c(x) & "falls" P(x) & "(Basisfall)",
  h(x\, f(phi(x))) & "sonst" & "(allgemeiner Fall)"
) $

Dabei bezeichnet $P(x)$ die Abbruchbedingung, $phi$ die Vorgängerfunktion, welche das Argument in Richtung Basisfall verkleinert, und $h$ die Schrittfunktion, die aus dem aktuellen Argument und dem Ergebnis des rekursiven Aufrufs den neuen Wert berechnet.

== Historischer Hintergrund

Die Geschichte der Rekursion reicht weit zurück. Den ersten bekannten rekursiven Algorithmus lieferte Euklid im dritten Jahrhundert vor Christus mit dem Verfahren der wechselnden Wegnahme zur Berechnung des #acr("GGT") zweier ganzer Zahlen. Die Grundidee ist bestechend einfach: Haben zwei Stäbe der Längen $a$ und $b$ ein gemeinsames Maß, so hat auch der kürzere Stab und die Differenz der beiden Stäbe ein gemeinsames Maß. Das Verfahren wird solange wiederholt, bis beide Stäbe gleich lang sind – das ist dann der gesuchte größte gemeinsame Teiler @lorenz2012.

Im 19. Jahrhundert formalisierte Richard Dedekind den Begriff der rekursiven Definition im Rahmen der Peano-Axiome für die natürlichen Zahlen. Die Grundoperationen Addition und Multiplikation werden dort nicht durch explizite Formeln, sondern durch rekursive Schemata definiert. Im 20. Jahrhundert wurde Rekursion durch die Arbeiten von David Hilbert, Kurt Gödel und Alonzo Church zum zentralen Gegenstand der mathematischen Logik und der Berechenbarkeitstheorie. Der Begriff „rekursiv" im modernen Sinne wurde erstmals von Gödel in seinen Arbeiten über primitive und allgemein rekursive Funktionen verwendet.

In der Informatik etablierte sich Rekursion spätestens mit der Entwicklung der Programmiersprache LISP in den späten 1950er Jahren als fundamentales Konzept. John McCarthy, der Entwickler von LISP, erkannte, dass sich viele Berechnungen auf natürliche Weise als rekursive Funktionsdefinitionen ausdrücken lassen – eine Einsicht, die die gesamte Entwicklung der funktionalen Programmierung prägte.

== Strukturelle Rekursion und induktive Datentypen

Ein besonders wichtiges Konzept ist die *#gls("Strukturelle_Rekursion")*. Sie tritt auf, wenn eine rekursive Funktion der Struktur ihres Eingabedatentyps folgt. Induktiv definierte Datentypen – also Typen, die entweder ein Basisobjekt oder eine Kombination aus einfacheren Objekten desselben Typs sind – und strukturell rekursive Funktionen über ihnen besitzen eine tiefe strukturelle Gleichheit @lorenz2012. Die natürlichen Zahlen etwa sind entweder die Null oder der Nachfolger einer natürlichen Zahl; eine Funktion, die über natürliche Zahlen rekursiv arbeitet, behandelt entsprechend den Fall Null als Basisfall und den Nachfolger-Fall als allgemeinen Fall. Diese Parallelität ist kein Zufall, sondern ein fundamentales Prinzip: Die Struktur korrekter rekursiver Programme spiegelt stets die Struktur der Daten wider, auf denen sie operieren.

#figure(
  caption: "Strukturelle Parallele zwischen induktivem Datentyp und rekursiver Funktion",
  table(
    columns: (1fr, 1fr),
    inset: 10pt,
    align: horizon,
    table.header([*Natürliche Zahlen (induktiv)*], [*Rekursive Funktion f(n)*]),
    [$0$ → Basisfall], [$f(0) = c_0$ → Basisfall],
    [Nachfolger $n' = n+1$], [$f(n) = h(n, f(n-1))$ → allg. Fall],
  )
)

= Rekursive Funktionen

== Grundprinzip und das Fakultätsbeispiel

Das bekannteste Einführungsbeispiel für eine rekursive Funktion ist die Fakultät. Mathematisch ist sie definiert als das Produkt aller positiven ganzen Zahlen bis einschließlich $n$. Statt diese Summe mit Pünktchenschreibweise anzudeuten, lässt sich die Fakultät präzise rekursiv erfassen: Die Fakultät von Null ist Eins (Basisfall), und die Fakultät einer beliebigen positiven Zahl $n$ ist $n$ multipliziert mit der Fakultät von $n-1$ (allgemeiner Fall). Diese Definition beschreibt exakt das Berechnungsverfahren: Um $n!$ zu berechnen, muss man erst $(n-1)!$ kennen, um $(n-1)!$ zu berechnen, muss man $(n-2)!$ kennen, und so fort, bis man beim Basisfall $0! = 1$ angelangt ist.

In Java lässt sich diese mathematische Definition direkt als Methode umschreiben. Die `if`-Verzweigung entspricht dabei exakt der mathematischen Fallunterscheidung: Der Basisfall $n = 0$ wird explizit abgefangen und liefert sofort den Wert $1$ zurück. Für alle anderen Werte ruft sich die Methode mit dem um Eins verkleinerten Argument selbst auf und multipliziert das Ergebnis anschließend mit $n$.

#figure(
  caption: "Rekursive Fakultät in Java",
  sourcecode[```java
  public static long factorial(int n) {
      if (n == 0) {
          return 1;           // Basisfall
      }
      return n * factorial(n - 1);  // allgemeiner Fall
  }
  ```]
)

Der Aufruf `factorial(4)` löst dabei die folgende Aufrufkette aus: `factorial(4)` wartet auf `factorial(3)`, dieses auf `factorial(2)`, dieses auf `factorial(1)`, und erst `factorial(0)` liefert direkt $1$ zurück. Danach werden die Ergebnisse in umgekehrter Reihenfolge zusammengesetzt: $1 dot 1 = 1$, $2 dot 1 = 2$, $3 dot 2 = 6$, $4 dot 6 = 24$.

== Terminierung und Korrektheit

Eine zentrale Frage bei jeder rekursiven Funktion ist die der Terminierung: Kommt die Berechnung irgendwann zu einem Ende, oder läuft sie unendlich lange? Eine rekursive Funktion terminiert genau dann für alle Eingaben, wenn die Vorgängerfunktion $phi$ das Argument monoton auf den Basisfall zuführt, also bei jedem Schritt eine wohldefinierte Größe strikt abnimmt @lorenz2012. Beim Fakultätsbeispiel ist diese Größe das Argument selbst: es wird bei jedem Aufruf um genau Eins verkleinert und erreicht schließlich den Basisfall Null.

Nicht jede rekursive Funktion terminiert für alle Eingaben. Sogenannte partiell berechenbare Funktionen sind nur für einen Teil ihrer möglichen Argumente definiert. Dies führt in der Praxis zum gefürchteten „Hängen" eines Programms – das Programm antwortet nicht mehr, weil es in einem unendlichen Rekursionszyklus gefangen ist. Lorenz beschreibt dieses Phänomen treffend: _„Keine Antwort ist auch keine Antwort"_ @lorenz2012.

== Endrekursion

Ein praktisches Problem naiver Rekursion ist der Speicherverbrauch. Bei jedem Funktionsaufruf legt das Laufzeitsystem einen neuen Eintrag auf dem Aufrufstapel (Call Stack) an, der den lokalen Zustand der Berechnung festhält. Bei tiefer Rekursion kann dieser Stapel überlaufen – ein sogenannter Stack Overflow. Die *#gls("Endrekursion")* bietet eine elegante Lösung: Eine Funktion ist endrekursiv, wenn der rekursive Aufruf die allerletzte Operation der Funktion ist und dessen Ergebnis direkt zurückgegeben wird, ohne danach noch mit einem weiteren Wert verknüpft zu werden. In diesem Fall benötigt der Compiler den bisherigen Stackframe nicht mehr und kann ihn wiederverwenden, anstatt einen neuen anzulegen. Diese Optimierung heißt _Tail Call Optimization_ und ist in Haskell sowie den meisten anderen funktionalen Sprachen garantiert. Endrekursive Funktionen sind damit in ihrem Speicherverbrauch äquivalent zu imperativen Schleifen.

Um die Fakultätsfunktion endrekursiv zu machen, wird ein Akkumulator eingeführt, der das bisherige Zwischenergebnis mitführt. Statt das Ergebnis des rekursiven Aufrufs noch mit $n$ multiplizieren zu müssen, wird die Multiplikation bereits vor dem Aufruf durchgeführt und dem Akkumulator übergeben.

== Gegenseitige und verschachtelte Rekursion

Neben der direkten Rekursion, bei der eine Funktion sich selbst aufruft, gibt es weitere Varianten. Bei der *gegenseitigen Rekursion* rufen sich zwei oder mehr Funktionen wechselseitig auf. Ein klassisches Beispiel sind die Funktionen `isEven` und `isOdd`: eine Zahl ist gerade, wenn ihr Vorgänger ungerade ist, und ungerade, wenn ihr Vorgänger gerade ist. Bei der *verschachtelten Rekursion* tritt der Selbstaufruf als Argument eines weiteren Selbstaufrufs auf. Das bekannteste Beispiel ist die Ackermann-Funktion, die zwar für alle natürlichen Zahlen terminiert, aber so schnell wächst, dass sie praktisch nicht berechenbar ist und auch nicht durch das primitive Rekursionsschema erfasst werden kann @lorenz2012.

= Rekursive Datenstrukturen

== Das Konzept induktiver Datentypen

Nicht nur Funktionen, sondern auch Datenstrukturen können rekursiv definiert sein. Ein rekursiver Datentyp ist ein Typ, dessen Definition sich auf sich selbst bezieht – analog zur rekursiven Funktionsdefinition mit einem Basisfall und einem allgemeinen Fall. Solche Typen werden in der Informatik auch als *induktive Datentypen* bezeichnet, weil man alle möglichen Werte des Typs konstruktiv „aufzählen" kann: Man beginnt mit dem Basisfall und erzeugt durch wiederholte Anwendung des allgemeinen Falls alle weiteren Werte @block2011.

Der Vorteil rekursiver Datentypen liegt in ihrer natürlichen Beschreibungskraft: Viele Probleme besitzen eine inhärent rekursive Struktur, und induktive Datentypen ermöglichen es, diese Struktur direkt im Programmcode abzubilden. Funktionale Sprachen wie Haskell haben diese Idee zur zentralen Grundlage ihres Typsystems gemacht.

== Listen

Die Liste ist der prototypische rekursive Datentyp in der funktionalen Programmierung. Eine Liste ist entweder leer oder sie besteht aus einem ersten Element (dem Kopf) und einer weiteren Liste (dem Schwanz). Diese Definition ist vollständig induktiv: Der Basisfall ist die leere Liste, und der allgemeine Fall kombiniert ein beliebiges Element mit einer bereits bestehenden Liste zu einer neuen, längeren Liste @block2011.

In Haskell wird diese Struktur direkt durch Pattern Matching ausgenutzt. Funktionen über Listen folgen zwingend diesem Aufbau: Sie behandeln die leere Liste als Basisfall und zerlegen im allgemeinen Fall die Liste in Kopf und Schwanz. Die Länge einer Liste ist Null, wenn sie leer ist, andernfalls Eins plus die Länge des Schwanzes. Die Summe einer leeren Liste ist Null, andernfalls das erste Element plus die Summe der restlichen Elemente. Dieses Muster zieht sich durch praktisch alle Listenoperationen und macht den Code nicht nur knapp, sondern auch leicht nachvollziehbar.

== Bäume

Bäume sind ein weiterer wichtiger rekursiver Datentyp, der in der Informatik allgegenwärtig ist – von Dateisystemen über Syntaxbäume von Programmiersprachen bis hin zu Datenbanken. Ein Binärbaum ist entweder ein leeres Blatt (Basisfall) oder ein Knoten, der einen Wert sowie einen linken und einen rechten Teilbaum enthält (allgemeiner Fall). Auch hier folgt die Struktur des Datentyps direkt der Struktur der rekursiven Funktionen, die ihn verarbeiten: Um die Tiefe eines Baumes zu bestimmen, berechnet man rekursiv die Tiefen des linken und rechten Teilbaums und nimmt das Maximum. Der Basisfall – ein leeres Blatt – hat die Tiefe Null.

= Rekursion im Kontext der funktionalen Programmierung

== Rekursion als Ersatz für Schleifen

In imperativen Programmiersprachen wie Java oder C werden Wiederholungen durch Schleifen ausgedrückt. Eine `for`-Schleife etwa wiederholt einen Block von Anweisungen, während eine Zählvariable verändert wird. In rein funktionalen Sprachen hingegen gibt es keine veränderbaren Variablen – ein Wert, dem einmal ein Ausdruck zugewiesen wurde, bleibt unveränderlich. Damit ist das Konzept einer Schleife mit veränderbarem Zustand grundsätzlich nicht realisierbar @pepper2006.

Rekursion übernimmt diese Rolle vollständig. Was imperative Programmierung durch Zustandsveränderung ausdrückt, drückt funktionale Programmierung durch Parameterübergabe aus: Statt eine Variable zu inkrementieren, übergibt man den neuen Wert als Argument an den nächsten rekursiven Aufruf. Das Ergebnis ist semantisch äquivalent, aber ohne jeden veränderbaren Zustand. Durch _Tail Call Optimization_ ist diese Form der Rekursion auch hinsichtlich Laufzeit und Speicherbedarf mit Schleifen gleichwertig.

== Lazy Evaluation und unendliche Strukturen

Ein bemerkenswertes Merkmal von Haskell ist die sogenannte _lazy evaluation_ (bedarfsgesteuerte Auswertung): Ausdrücke werden erst dann berechnet, wenn ihr Wert tatsächlich benötigt wird. In Verbindung mit Rekursion ermöglicht dies die Definition potenziell unendlicher Datenstrukturen. Eine unendliche Liste aller natürlichen Zahlen lässt sich in Haskell direkt hinschreiben, da die Sprache nur so viele Elemente tatsächlich berechnet, wie später abgefragt werden. Dieses Konzept wird auch als _Stream_ bezeichnet und verbindet Rekursion eng mit dem Thema Listen und Streams @krypczyk2021.

== Verbindung zum Lambda-Kalkül

Im reinen Lambda-Kalkül, dem theoretischen Fundament der funktionalen Programmierung, gibt es zunächst keine direkte Möglichkeit, benannte, sich selbst aufrufende Funktionen zu definieren. Rekursion wird dort durch den *Y-Kombinator* realisiert, einen sogenannten Fixpunktoperator. Er nimmt eine Funktion entgegen und gibt deren Fixpunkt zurück – also denjenigen Wert $f(x) = x$, der unter wiederholter Anwendung der Funktion unverändert bleibt. Mithilfe des Y-Kombinators lässt sich jede rekursive Funktion in eine äquivalente, nicht-rekursive Form im Lambda-Kalkül überführen. Dies beweist, dass Rekursion keine primitive Sprachfunktion sein muss, sondern sich aus einfachsten Grundbausteinen konstruieren lässt @pepper2006.

== Höherwertige Funktionen als verallgemeinerte Rekursion

In der Praxis wird in Haskell Rekursion oft nicht explizit ausgeschrieben, sondern durch höherwertige Funktionen abstrahiert. Funktionen wie `map`, `filter` und `foldr` kapseln wiederkehrende Rekursionsmuster und machen den Code kürzer und ausdrucksstärker. `foldr` etwa ist eine Verallgemeinerung der strukturellen Rekursion über Listen: Es nimmt eine Funktion und einen Startwert entgegen und kombiniert alle Listenelemente durch rekursive Anwendung dieser Funktion. Viele bekannte Listenoperationen – Summe, Produkt, Länge, Umkehrung – lassen sich als Spezialfall von `foldr` darstellen. Diese höherwertigen Funktionen sind selbst rekursiv implementiert; sie machen die Rekursion für den Programmierer unsichtbar, ohne das zugrunde liegende Prinzip zu ändern @block2011.

= Fazit

Rekursion ist weit mehr als ein Programmiertrick – sie ist ein grundlegendes Denkprinzip, das Mathematik und Informatik seit Jahrtausenden durchzieht. Die Idee, ein Problem durch Rückführung auf eine einfachere Version desselben Problems zu lösen, begegnet uns von Euklids Algorithmus bis hin zu modernen Typsystemen.

In der funktionalen Programmierung nimmt Rekursion eine besonders zentrale Stellung ein. Da unveränderliche Werte klassische Schleifen ausschließen, ist Rekursion das einzige Wiederholungsprinzip. Gleichzeitig ermöglicht die enge Verbindung zwischen induktiven Datentypen und strukturell rekursiven Funktionen einen klaren, mathematisch fundierten Programmierstil: Die Korrektheit eines Programms lässt sich oft direkt aus der Struktur des Datentyps ablesen, und die Implementierung ergibt sich fast zwingend aus der Problemdefinition.

Konzepte wie Endrekursion und bedarfsgesteuerte Auswertung zeigen, dass Rekursion nicht nur elegant, sondern auch effizient sein kann. Haskell demonstriert eindrucksvoll, wie ein vollständig auf Rekursion und unveränderlichen Werten aufgebautes Sprachdesign zu ausdrucksstarker, wartbarer und theoretisch fundierter Software führt. Das Verständnis von Rekursion ist daher nicht nur akademisch wertvoll, sondern eine unverzichtbare Grundlage für das Denken in modernen Programmierkonzepten.
