import java.util.Arrays;

/**
	*@author Josué Romero
	*@param 13/abril/2022 - 21:55 COL
*/
public class Fibonacci {
	
	public static void main(String[] args) {
		// Mostraré la serie de fibonacci hasta el 1597
		int acc[] = new int[20];
		acc[0] = 0;
		acc[1] = 1;

		for (int i = 2; i <= 19; i++) {
			acc[i] = (acc[i-2] + acc[i-1]);
		}
		System.out.println("Los primeros 20 números de la sucesión de fibonacci son:\n" + Arrays.toString(acc));
	}
:
