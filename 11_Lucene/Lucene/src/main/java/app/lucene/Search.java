package app.lucene;

import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.StoredFields;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.nio.file.Paths;


public class Search {
    private static final String INDEX_DIRECTORY = "src/main/resources/index";

    public static void main(String[] args) {
        try {
            PolishAnalyzer analyzer = new PolishAnalyzer();
            Directory directory = FSDirectory.open(Paths.get(INDEX_DIRECTORY));

            String querystr = "naturalne";
            Query q = new QueryParser("title", analyzer).parse(querystr);
            int maxHits = 10;
            IndexReader reader = DirectoryReader.open(directory);
            IndexSearcher searcher = new IndexSearcher(reader);
            TopDocs docs = searcher.search(q, maxHits);
            ScoreDoc[] hits = docs.scoreDocs;

            System.out.println("Found " + hits.length + " matching docs.");
            StoredFields storedFields = searcher.storedFields();
            for(int i=0; i<hits.length; ++i) {
                int docId = hits[i].doc;
                Document d = storedFields.document(docId);
                System.out.println((i + 1) + ". " + d.get("isbn")
                        + "\t" + d.get("title"));
            }
            reader.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

// nowe pliki są dodawane (widzoczne w resource - '_0', '_1', '_2', itd)
// wyszukiwanie przeszukuje wszystkie indeksy, a więc wyniki są powielane
