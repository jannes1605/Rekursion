#import "@preview/supercharged-dhbw:3.4.1": *
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
  at-university: false,
  bibliography: bibliography("sources.bib"),
  date: datetime(year: 2026, month: 5, day: 8),
  supervisor: (university: "Edelbert Schumm"),
  glossary: glossary,
  language: "de",
  university: "Duale Hochschule Baden-Württemberg",
  university-location: "Mannheim",
  university-short: "DHBW",
  show-confidentiality-statement: false,
  show-declaration-of-authorship: false,
  show-list-of-tables: false,
  show-list-of-figures: false,
  show-code-snippets: false,
  show-acronyms: false,
)


= Einleitung

Rekursion begegnet uns häufiger, als man zunächst denkt. Ob das Blätterwerk eines Baumes, verschachtelte Ordnerstrukturen auf dem Computer oder die Grammatik einer Programmiersprache – viele Dinge sind von Natur aus rekursiv aufgebaut. In der Mathematik kennt man das schon lange: Die Fakultät, Folgen oder der euklidische Algorithmus basieren alle auf demselben Prinzip, auch wenn es dort selten so genannt wird.

In der funktionalen Programmierung ist Rekursion noch zentraler: Da Sprachen wie Haskell keine veränderbaren Variablen kennen, gibt es auch keine klassischen Schleifen. Stattdessen werden Wiederholungen immer durch Rekursion ausgedrückt @pepper2006. Diese Ausarbeitung erklärt, was Rekursion ist, wie sie funktioniert, welche Varianten es gibt und wie sie in der Praxis eingesetzt wird @infschule2024 @lenz_rekursion.

= Definition und Grundlagen

== Was ist Rekursion?

Moritz Lenz beschreibt Rekursion treffend so: _„Eine Funktion macht nur einen kleinen Teil der Arbeit, verkleinert das Problem damit ein bisschen, und ruft sich dann selbst auf, um den Rest zu lösen."_ @lenz_rekursion Lorenz ergänzt: _„Man definiert etwas nicht explizit, sondern durch einfachere Versionen seiner selbst."_ @lorenz2012

Das Prinzip dahinter heißt *rekursive Problemreduktion*: Ein Problem wird auf ein strukturgleiches, aber kleineres Problem zurückgeführt – immer wieder, bis man bei einem Fall ankommt, den man direkt lösen kann @infschule2024. Die wiederholte Ausführung überlässt man dabei komplett dem Programmiersystem, man beschreibt nur die Struktur der Lösung.

Damit das nicht ewig weitergeht, braucht jede Rekursion zwei Teile:

- *Basisfall* (auch Rekursionsanfang): Der einfachste Fall, der direkt beantwortet werden kann – ohne weiteren Selbstaufruf. Er sorgt dafür, dass die Rekursion irgendwann aufhört.
- *Allgemeiner Fall* (auch Reduktionsschritt): Das aktuelle Problem wird auf ein kleineres Problem desselben Typs zurückgeführt. Wichtig: Die Verkleinerung muss nach endlich vielen Schritten zum Basisfall führen @infschule2024.

== Strukturelle Rekursion

Besonders wichtig ist die *strukturelle Rekursion*: Eine Funktion folgt dabei dem Aufbau des Datentyps, den sie verarbeitet. Wenn ein Datentyp selbst rekursiv definiert ist, ergibt sich die passende Funktion darüber fast automatisch @lorenz2012.

Das zeigt sich gut an den natürlichen Zahlen: Man kann sie induktiv beschreiben – entweder ist eine Zahl die Null (Basisfall), oder sie ist der Nachfolger einer anderen natürlichen Zahl (allgemeiner Fall). Eine Funktion über natürliche Zahlen behandelt genau diese zwei Fälle:

#figure(
  caption: "Strukturelle Entsprechung zwischen Datentyp und Funktion",
  table(
    columns: (auto, 1fr, 1fr),
    inset: 9pt,
    align: (center, left, left),
    table.header([], [*Natürliche Zahlen*], [*Rekursive Funktion f(n)*]),
    [*Basisfall*],
    [Die Zahl 0 existiert.],
    [Für $n = 0$ gibt es eine direkte Antwort, z.B. $f(0) = 1$ bei der Fakultät.],
    [*Allg. Fall*],
    [Jedes $n > 0$ ist der Nachfolger von $n-1$.],
    [Für $n > 0$ wird $f(n-1)$ berechnet und mit $n$ verknüpft: $f(n) = n dot f(n-1)$.],
  )
)

Das Prinzip: Wer den Aufbau des Datentyps kennt, weiß bereits, welche Fälle die Funktion behandeln muss.

= Rekursive Funktionen

== Das Fakultätsbeispiel

Die Fakultät ist das klassische Beispiel. Sie ist definiert als das Produkt aller ganzen Zahlen von 1 bis $n$, also z.B. $4! = 1 dot 2 dot 3 dot 4 = 24$. Rekursiv lässt sich das so ausdrücken: Die Fakultät von 0 ist 1 (Basisfall), und für alle anderen $n$ gilt $n! = n dot (n-1)!$ (allgemeiner Fall).

In Java schreibt sich das fast genauso:

#figure(
  caption: "Rekursive Berechnung der Fakultät in Java",
  sourcecode[```java
  public static long factorial(int n) {
      if (n == 0) {
          return 1;                 // Basisfall
      }
      return n * factorial(n - 1); // allgemeiner Fall
  }
  ```]
)

Zum Vergleich dieselbe Funktion in Scala – kürzer, ohne veränderbare Variablen:

#figure(
  caption: "Dieselbe Funktion in Scala",
  table(
    columns: (1fr, 1fr),
    inset: 8pt,
    align: left,
    table.header([*Java*], [*Scala*]),
    [```java
public static long factorial(int n) {
    if (n == 0) { return 1; }
    return n * factorial(n - 1);
}
    ```],
    [```scala
def factorial(n: Int): Long =
  if n == 0 then 1
  else n * factorial(n - 1)
    ```],
  )
)

Was passiert beim Aufruf `factorial(4)`? Abbildung 2 zeigt den Aufrufstapel (Call Stack): Die Methode ruft sich selbst auf, bis sie bei `factorial(0)` ankommt und direkt 1 zurückgibt. Danach werden die Ergebnisse schrittweise rückwärts aufgelöst.

#figure(
  caption: "Aufrufstapel bei factorial(4) – Aufbau (links) und Auflösung (rechts)",
  block(
    width: 100%,
    grid(
      columns: (1fr, 0.15fr, 1fr),
      gutter: 0pt,
      // Linke Seite: Aufbau
      align(center)[
        #set text(size: 9pt)
        #table(
          columns: (1fr),
          inset: 6pt,
          align: center,
          fill: (_, row) => if row == 0 { rgb("#d0e8ff") } else { white },
          [*Aufbau des Stapels*],
          [`factorial(4)` wartet auf `factorial(3)`],
          [`factorial(3)` wartet auf `factorial(2)`],
          [`factorial(2)` wartet auf `factorial(1)`],
          [`factorial(1)` wartet auf `factorial(0)`],
          [`factorial(0)` → gibt *1* zurück],
        )
      ],
      // Pfeil in der Mitte
      align(center + horizon)[
        #set text(size: 14pt)
        *→*
      ],
      // Rechte Seite: Auflösung
      align(center)[
        #set text(size: 9pt)
        #table(
          columns: (1fr),
          inset: 6pt,
          align: center,
          fill: (_, row) => if row == 0 { rgb("#d4f4dd") } else { white },
          [*Auflösung des Stapels*],
          [`factorial(1)` = 1 × 1 = *1*],
          [`factorial(2)` = 2 × 1 = *2*],
          [`factorial(3)` = 3 × 2 = *6*],
          [`factorial(4)` = 4 × 6 = *24*],
          [Ergebnis: *24*],
        )
      ],
    )
  )
)

== Terminierung

Eine Rekursion muss irgendwann aufhören. Das funktioniert nur, wenn das Argument bei jedem Aufruf strikt kleiner wird und irgendwann den Basisfall erreicht @lorenz2012 @infschule2024. Bei der Fakultät nimmt $n$ bei jedem Schritt um genau 1 ab – das führt zwingend zu $n = 0$.

Fehlt der Basisfall oder wird das Argument nicht verkleinert, läuft die Rekursion endlos. In Java endet das mit einem `StackOverflowError`, weil für jeden offenen Aufruf Speicher auf dem Aufrufstapel belegt wird – und der ist nicht unbegrenzt groß.

== Endrekursion

Genau dieser Speicherverbrauch ist ein praktisches Problem bei tiefer Rekursion. Bei der normalen Fakultät muss Java sich für jeden offenen Aufruf merken, mit welchem $n$ es noch multiplizieren muss. Das ergibt bei $n = 10.000$ auch 10.000 offene Einträge auf dem Stack.

Die *Endrekursion* (englisch: tail recursion) löst das: Eine Funktion ist endrekursiv, wenn der rekursive Aufruf die allerletzte Operation ist und das Ergebnis direkt zurückgegeben wird – ohne dass danach noch etwas damit passiert. Der Compiler kann dann den alten Stackeintrag einfach wiederverwenden. Dafür führt man einen Akkumulator ein, der das Zwischenergebnis mitträgt:

Statt `return n * factorial(n-1)` (Multiplikation nach dem Aufruf) schreibt man den rekursiven Aufruf so, dass die Multiplikation bereits vorher erledigt und als Parameter übergeben wird.

Warum hilft das in Java nicht? Die JVM (Java Virtual Machine) unterstützt Endrekursionsoptimierung grundsätzlich nicht automatisch. Das liegt daran, dass die JVM vollständige Stack-Traces für Debugging und Fehleranalyse benötigt – sie muss also jeden Aufruf im Stapel behalten @odersky2021. Scala löst das anders: Die Annotation `@tailrec` weist den Scala-Compiler an, eine endrekursive Funktion *vor* der Übersetzung in JVM-Bytecode in eine einfache Schleife umzuwandeln. Es handelt sich also um eine Compiler-Transformation, nicht um ein JVM-Feature. In Java bleibt man deshalb besser bei einer `for`-Schleife, wenn der Eingabewert groß sein kann @lorenz2012.

== Weitere Varianten

Bei der *gegenseitigen Rekursion* rufen sich zwei Funktionen abwechselnd auf. Zum Beispiel: `istGerade(n)` ruft `istUngerade(n-1)` auf, und umgekehrt. Beide bilden zusammen eine Rekursion, bis der Basisfall ($n = 0$) erreicht ist @lenz_rekursion.

Bei der *verschachtelten Rekursion* ist der Selbstaufruf selbst wieder ein Argument eines weiteren Selbstaufrufs. Das bekannteste Beispiel ist die *Ackermann-Funktion*. Sie ist für alle natürlichen Zahlen berechenbar und terminiert immer – aber sie wächst so extrem schnell, dass sie schon für kleine Eingaben astronomische Werte annimmt.

Wichtig dabei: Die Ackermann-Funktion ist *nicht* primitiv-rekursiv. Primitiv-rekursiv bedeutet, dass sich eine Funktion auf eine Schleife mit vorher fest bekannter Schrittzahl zurückführen lässt – man weiß also bereits vor dem Start, wie oft man wiederholt. Einfache Funktionen wie Fakultät oder Addition sind primitiv-rekursiv. Bei der Ackermann-Funktion hingegen hängt die Anzahl der Schritte selbst von einem rekursiv berechneten Wert ab – sie entzieht sich damit jeder Schleife mit fester Laufzahl. Das zeigt, dass Rekursion ausdrucksstärker ist als Schleifen @lorenz2012.

Ein praktisches Beispiel für Rekursion aus dem Alltag der Softwareentwicklung ist *Merge Sort*: Der Algorithmus teilt eine unsortierte Liste in der Mitte, sortiert beide Hälften jeweils rekursiv und fügt sie danach sortiert wieder zusammen. Der Basisfall ist eine Liste mit nur einem Element – die ist bereits sortiert. Lenz beschreibt das Prinzip so: Rekursion zerlegt größere Probleme auf natürliche Weise in kleinere, was die Lösung erheblich vereinfacht @lenz_rekursion. Merge Sort erreicht damit eine Laufzeit von $O(n log n)$ – deutlich besser als einfache Verfahren wie Bubblesort mit $O(n^2)$. Er ist kein akademisches Konstrukt, sondern in vielen Standardbibliotheken als realer Sortieralgorithmus implementiert @sedgewick2011.

= Rekursive Datenstrukturen

Nicht nur Funktionen, sondern auch Datenstrukturen können rekursiv aufgebaut sein. Man nennt sie *induktive Datentypen*: Ihre Definition besteht aus einem Basisfall und einem allgemeinen Fall, der auf den Typ selbst verweist @block2011.

*Listen* sind das bekannteste Beispiel. Eine Liste ist entweder leer (Basisfall) oder sie hat ein erstes Element (Kopf) und dahinter eine weitere Liste (Schwanz). Funktionen über Listen folgen genau diesem Aufbau: Der Basisfall behandelt die leere Liste direkt, der allgemeine Fall verarbeitet den Kopf und ruft sich rekursiv für den Schwanz auf. Die Länge einer leeren Liste ist 0, sonst 1 plus die Länge des Schwanzes – ganz einfach.

*Bäume* funktionieren genauso. Ein Binärbaum ist entweder ein leeres Blatt (Basisfall) oder ein Knoten mit einem Wert und zwei Teilbäumen (allgemeiner Fall). Die Tiefe eines Baumes berechnet man rekursiv: Man fragt die Tiefen des linken und rechten Teilbaums ab und nimmt das Maximum. Ein leeres Blatt hat Tiefe 0.

Der Vorteil: Wenn man den Aufbau der Datenstruktur kennt, ergibt sich die Struktur der passenden Funktion von selbst. Das macht rekursive Programme über solche Typen leichter zu schreiben und zu verstehen @block2011.

= Rekursion in der funktionalen Programmierung

In Sprachen wie Java benutzt man `for`- oder `while`-Schleifen für Wiederholungen. In rein funktionalen Sprachen wie Haskell gibt es das nicht – Werte sind unveränderlich (*Immutability*), also kann man keine Schleifenvariable hochzählen. Rekursion übernimmt dort komplett die Rolle der Schleifen: Statt `i++` übergibt man den neuen Wert einfach als Argument an den nächsten Aufruf @pepper2006.

Scala zeigt den Unterschied gut, weil es beide Welten kennt. Die iterative Java-Variante der Fakultät verändert in jeder Runde `result` und `i`. Die rekursive Scala-Variante kommt ohne veränderbare Variablen aus – mit `@tailrec` wandelt der Compiler sie außerdem automatisch in eine Schleife um, sodass kein Stacküberlauf entstehen kann @odersky2021. Das Ergebnis ist in beiden Fällen gleich, der Weg dorthin unterscheidet sich grundlegend.

= Fazit

Rekursion ist kein komplizierter Trick, sondern ein natürliches Denkprinzip: Man löst ein Problem, indem man es auf eine kleinere Version desselben Problems zurückführt. Das haben Menschen schon vor mehr als 2000 Jahren gemacht – mit dem euklidischen Algorithmus.

In der funktionalen Programmierung ist Rekursion besonders wichtig, weil es ohne veränderliche Variablen keine Schleifen geben kann. Wer versteht, wie induktive Datentypen aufgebaut sind, kann darüber fast automatisch korrekte rekursive Funktionen schreiben. Konzepte wie Endrekursion zeigen außerdem, dass rekursive Programme auch effizient sein können – nicht nur elegant.
