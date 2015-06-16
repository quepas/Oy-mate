import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
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
        List<CSVRecord> csvRecords = new ArrayList<CSVRecord>();
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


        /*SourceFile hmrFile = new SourceFile("D:/Programowanie/Projekty/Oy-mate/ml-auto-configuration-rules/rule.hmr");
        HMRParser parser = new HMRParser();
        State XTTState = new State();
        try {
            parser.parse(hmrFile);
            XTTModel model = parser.getModel();
            LinkedList<Table> tables = model.getTables();
            System.out.println("Tables:");
            for(Table table : tables){
                System.out.println("- " + table.getName());
                LinkedList<heart.xtt.Attribute> concl = table.getConclusion();
                System.out.println("Conlusions:");
                for(heart.xtt.Attribute attr : concl){
                    System.out.println("- " + attr.getName());
                }
                System.out.println("----------------------------------------------------------");
                System.out.println("Rules for table " + table.getName());
                System.out.println("----------------------------------------------------------");

                for(Rule rule : table.getRules()){
                    System.out.print("\nRule " + rule.getId() + ":\n\tif ");
                    for(Formulae formulae : rule.getConditions()){
                        System.out.print(formulae.getAttribute().getName() + " " +
                                         formulae.getOp() + " " +
                                         formulae.getValue() + ", ");
                    }
                    System.out.println("\n==>");
                    for(Decision decision: rule.getDecisions()){
                        System.out.println("\t" + decision.getAttribute().getName() + " set " + decision.getDecision());
                    }
                }
                for (int i = 0; i < csvAttributes.size(); ++i) {
                    String attr = csvAttributes.get(i);
                    Double value = csvValues.get(i);
                    StateElement stateElement = new StateElement();
                    stateElement.setAttributeName(attr);
                    stateElement.setValue(new SimpleNumeric(value));
                    XTTState.addStateElement(stateElement);
                }

                System.out.println("----------------------------------------------------------");
                System.out.println("HeaRT inference process");
                System.out.println("----------------------------------------------------------");
            }

            try{
                HeaRT.fixedOrderInference(model,
                        new String[]{"meta"},
                        new Configuration.Builder()
                                .setInitialState(XTTState)
                                .build());
            }catch(UnsupportedOperationException e){
                e.printStackTrace();
            } catch (BuilderException e) {
                e.printStackTrace();
            } catch (NotInTheDomainException e) {
                e.printStackTrace();
            } catch (AttributeNotRegisteredException e) {
                e.printStackTrace();
            }
            System.out.println("----------------------------------------------------------");
            System.out.println("Printing current state (after inference):");
            System.out.println("----------------------------------------------------------");
            State current = HeaRT.getWm().getCurrentState(model);
            String selectedClass = "None";
            for(StateElement stateElement : current){
                if (!(stateElement.getValue() instanceof Null)) {
                    System.out.println("\t" + stateElement.getAttributeName() + " = " + stateElement.getValue());
                    if (stateElement.getAttributeName().equals("class_attr")) {
                        selectedClass = stateElement.getValue().toString();
                    }
                }
            }
            System.out.println("----------------------------------------------------------");
            System.out.println("Selected class: " + selectedClass);
            System.out.println("----------------------------------------------------------");
        } catch (ParsingSyntaxException e) {
            e.printStackTrace();
        } catch (ModelBuildingException e) {
            e.printStackTrace();
        }
    }*/
}}
