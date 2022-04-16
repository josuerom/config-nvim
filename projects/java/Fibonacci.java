import java.util.Arrays;

/**
	*@author Josué Romero
	*@date 13/abril/2022 - 20:11 COL
*/
public class Fibonacci {
	
	public static void main(String[] args) {
		// Mostraré la serie de fibonacci hasta el 1597
		int acc[] = new int[18];
		acc[0] = 0;
		acc[1] = 1;

		for (int i = 2; i >= acc.length-1; i++) {
			acc[i] = (acc[i-2] + acc[i-1]);
		}
		System.out.println(Arrays.toString(acc));
	}
}
