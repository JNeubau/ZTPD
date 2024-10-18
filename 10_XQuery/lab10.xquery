(:5:)
for $author in doc("db/bib/bib.xml")//book/author/last
return $author

(:6:)
for $book in doc("db/bib/bib.xml")//book
return <ksiazka>
  {$book/author}  {$book/title}
</ksiazka>

(:7:)
for $book in doc("db/bib/bib.xml")//book
for $aut in $book/author
let $author_last := $aut/last
let $author_first := $aut/first
let $author := concat($author_last, 
$author_first)
return <ksiazka>
  <autor> {$author} </autor> 
  <tytul> {$book/title/text()} </tytul>
</ksiazka>

(:8:)
for $book in doc("db/bib/bib.xml")//book
for $aut in $book/author
let $author_last := $aut/last
let $author_first := $aut/first
let $author := concat($author_last, ' ',
$author_first)
return <ksiazka>
  <autor> {$author} </autor> 
  <tytul> {$book/title/text()} </tytul>
</ksiazka>

(:9:)
for $doc in doc("db/bib/bib.xml")
return <wynik> {
  for $book in $doc//book
  for $aut in $book/author
  let $author_last := $aut/last
  let $author_first := $aut/first
  let $author := concat($author_last, ' ',
  $author_first)
  return <ksiazka>
    <autor> {$author} </autor> 
    <tytul> {$book/title/text()} </tytul>
  </ksiazka>
}
</wynik>

(:10:)
for $doc in doc("db/bib/bib.xml")
return <imiona> {
  for $data_on_web in $doc//book[title='Data on the Web']/author
  return <imie>
  {$data_on_web/first/text()} 
  </imie>
}
</imiona>


(:11:)
for $doc in doc("db/bib/bib.xml")//book[title='Data on the Web']
return <DataOnTheWeb> 
  {$doc}
</DataOnTheWeb>

for $doc in doc("db/bib/bib.xml")//book
where $doc/title = 'Data on the Web'
return <DataOnTheWeb> 
  {$doc}
</DataOnTheWeb>


(:12:)
for $doc in doc("db/bib/bib.xml")
return <Data> {
  for $book in $doc//book
  where contains($book/title, 'Data')
  for $author in $book/author
  return <nazwisko>
    {$author/last/text()}
  </nazwisko>
}
</Data>


(:13:)
for $doc in doc("db/bib/bib.xml")
for $book in $doc//book
where contains($book/title, 'Data')
return <Data>
  {$book/title} 
  {
    for $author in $book/author
    return <nazwisko>
      {$author/last/text()}
    </nazwisko>
  }
</Data>


(:14:)
for $doc in doc("db/bib/bib.xml")
for $book in $doc//book
where count($book/author) <= 2
return <title>
  { $book/title/text() }
</title>


(:15:)
for $doc in doc("db/bib/bib.xml")
for $book in $doc//book
return <ksiazka>
  { $book/title }
  <author>{count($book/author)}</author>
</ksiazka>


(:16:)
let $years := for $doc in doc("db/bib/bib.xml")
        for $book in $doc//book
        return xs:integer($book/@year)
let $minYear := min($years)
let $maxYear := max($years)
return <years>
  {concat($minYear, ' - ', $maxYear)}
</years>


(:17:)
let $price := for $doc in doc("db/bib/bib.xml")
        for $book in $doc//book
        return $book/price
let $minPrice := min($price)
let $maxPrice := max($price)
return <roznica>
  {$maxPrice - $minPrice}
</roznica>


(:18:)
let $price := for $doc in doc("db/bib/bib.xml")
        for $book in $doc//book
        return $book/price
let $minPrice := min($price)
return <najtansze>
  {for $minBook in doc("db/bib/bib.xml")//book[price=$minPrice]
    return <najtansza>
      {$minBook/title}
      {for $author in $minBook/author
      return $author}
    </najtansza>}
</najtansze>


(:19:)
let $doc := doc("db/bib/bib.xml")
for $author in distinct-values($doc//author/last)
return <autor>
  <last>$author</last>
  {for $title in $doc//book[author/last=$author]/title
  return $title}
</autor>


(:20:)
let $doc := collection("db/shakespeare")
for $play in $doc
return $play//PLAY/TITLE


(:21:)
for $play in collection("db/shakespeare")
where contains($play/PLAY,'or not to be')
return $play//PLAY/TITLE


(:22:)
<wynik>{
for $play in collection("db/shakespeare")//PLAY
let $title := $play/TITLE
return
<sztuka tytul="{$title}">
  <postaci>{count($play//PERSONA)}</postaci>
    <aktow>{count($play//ACT)}</aktow>
    <scen>{count($play//SCENE)}</scen>
</sztuka>
}
</wynik>
