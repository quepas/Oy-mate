import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

/**
 * Created by Quepas on 2015-05-31.
 */
public class RuleConfigurator {

    public static void main(String[] args) {
        System.out.println("-------------------- RuleConfigurator --------------------");
        MetaAttrMatcher metaAttrMatcher = null;
        try {
            metaAttrMatcher = new MetaAttrMatcher(
                    "D:/Programowanie/Projekty/Oy-mate/ml-auto-configuration-rules/rule.hmr",
                    "D:/Programowanie/Projekty/Oy-mate/ml-auto-configuration-rules/qualities.csv");
        } catch (IOException e) {
            e.printStackTrace();
        }
        List<String> conclusions = metaAttrMatcher.inferenceAll();
        try {
            FileWriter fileWriter = new FileWriter("predictions.csv");
            fileWriter.write("did;algorithm\n");
            for (String entry : conclusions) {
                fileWriter.write(entry + "\n");
                System.out.println(entry);
            }
            fileWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
}}
