import java.io.*;

public class Input {
    public static void main(String[] args) {
        try {
            Reader r = new BufferedReader(new FileReader("/Users/davidmang/code/Compilers/Compiler/src/source.txt"));
            Lexer lexx = new Lexer(r);
            while (true){
                java_cup.runtime.Symbol next = lexx.next_token();
                if (next.sym == 0){
                    System.out.println("EOF");
                    break;
                }
                else{
                    System.out.println(" " + sym.terminalNames[next.sym]);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e){
            e.printStackTrace();
        }
    }
}