import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Quepas on 2015-06-26.
 */
public class RuleConfiguratorBatch {

    public static void main(String[] args) {
        System.out.println("-------------------- RuleConfigurator --------------------");
        if (args.length != 2) {
            System.out.println("Missing parameters. Set experiment directory and experiment name!");
            System.exit(1);
        }
        String dir = args[0];
        String name = args[1];

        String[] subexperiments = {"_A_5", "_A_15", "_A_50",
                                   "_B_5", "_B_15", "_B_50",
                                   "_C_5", "_C_15", "_C_50"};

        for (String exp : subexperiments) {
            String metaRules = dir + "/" + name + exp + ".hmr";
            //System.out.println("metaRules: " + metaRules);
            String metaAttr = dir + "/" + name + exp + "_meta_attributes.csv";
            //System.out.println("metaAttr: " + metaAttr);
            MetaAttrMatcher metaAttrMatcher = null;
            try {
                metaAttrMatcher = new MetaAttrMatcher(
                        metaRules,
                        metaAttr);
            } catch (IOException e) {
                e.printStackTrace();
            }
            List<String> conclusions = metaAttrMatcher.inferenceAll();
            try {
                FileWriter fileWriter = new FileWriter(dir + "/" + name + exp + "_predictions.csv");
                fileWriter.write("did,algorithm\n");
                for (String entry : conclusions) {
                    fileWriter.write(entry + "\n");
                    System.out.println(entry);
                }
                fileWriter.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
