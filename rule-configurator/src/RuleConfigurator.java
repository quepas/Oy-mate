import heart.Configuration;
import heart.HeaRT;
import heart.State;
import heart.StateElement;
import heart.alsvfd.Any;
import heart.alsvfd.Formulae;
import heart.alsvfd.Null;
import heart.alsvfd.SimpleNumeric;
import heart.alsvfd.expressions.ExpressionInterface;
import heart.exceptions.*;
import heart.parser.hmr.HMRParser;
import heart.parser.hmr.runtime.SourceFile;
import heart.xtt.*;

import java.util.LinkedList;

/**
 * Created by Quepas on 2015-05-31.
 */
public class RuleConfigurator {

    public static void main(String[] args) {
        System.out.println("-------------------- RuleConfigurator --------------------");
        SourceFile hmrFile = new SourceFile("D:/Programowanie/Projekty/Oy-mate/weka-rule-extraction/R/rule.hmr");
        HMRParser parser = new HMRParser();
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
                System.out.println("----------------------------------------------------------");
                System.out.println("HeaRT inference process");
                System.out.println("----------------------------------------------------------");
            }

            StateElement num = new StateElement();
            num.setAttributeName("MinorityClassSize");
            num.setValue(new SimpleNumeric(11111.0));
            StateElement num2 = new StateElement();
            num2.setAttributeName("MajorityClassSize");
            num2.setValue(new SimpleNumeric(12.0));
            State XTTState = new State();
            XTTState.addStateElement(num);
            XTTState.addStateElement(num2);

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
    }
}
