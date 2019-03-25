programa
{

	inclua biblioteca Arquivos --> arq
	inclua biblioteca Texto --> txt
	inclua biblioteca Util --> u
	inclua biblioteca Tipos --> t

	const inteiro LINHAS = 9
	const inteiro COLUNAS = 9
	caracter matriz[LINHAS][COLUNAS]	
	caracter matriz3x3[3][3]
	caracter numeros_dados[LINHAS][COLUNAS]

	cadeia mensagem_erro = ""

	const cadeia CAMINHO_ARQUIVO_TABULEIRO = "tabuleiro_dado.txt"
	const cadeia CAMINHO_ARQUIVO_RESULTADO = "resultado.txt"
	inteiro endereco_tabuleiro = arq.abrir_arquivo("tabuleiro_dado.txt", arq.MODO_LEITURA)
	inteiro endereco_resultado = arq.abrir_arquivo("resultado.txt", arq.MODO_ESCRITA)

	inteiro linha_com_erro = 0
	inteiro coluna_com_erro = 0

	inteiro x = 0
	inteiro y = 0
	
	funcao vazio printaTabuleiro(){
		/*escreva(" ")
		para(inteiro g = 0; g < COLUNAS; g++){
			escreva(" ", g+1)
		}
		escreva("\n ")
		para(inteiro h = 0; h < COLUNAS; h++){
			escreva(" -")
		}
		para(inteiro i = 0; i < LINHAS; i++){
			escreva("\n", i+1, "|")
			para(inteiro j = 0; j < COLUNAS; j++){
				se(j == COLUNAS-1)
					escreva(matriz[i][j])
				senao
					escreva(matriz[i][j], ";")
			}
			escreva("\n")
		}*/
	}

	/*popula a matriz com o conteúdo do tabuleiro txt
	 * e valida se os caracteres são válidos 
	 * ou se a linha tem menos de 17 caracteres
	 * (9 números ou #'s + 8 separadores)
	 * também chama a função popula a matriz de numeros dados usada na função loop
	 */
	funcao vazio setup(){
		para(inteiro i = 0; i < LINHAS; i++){
			cadeia linha = arq.ler_linha(endereco_tabuleiro)
			inteiro aux = 0
			para(inteiro j = 0; j < COLUNAS; j++){
				caracter c = txt.obter_caracter(linha, aux)
				se(nao(caracterEhValido(c))){
					//'e' é apenas um apelido para erro :P
					c = 'e'
				}
				matriz[i][j] = c
				aux+=2
			}		
		}
		populaNumerosDados()
		arq.fechar_arquivo(endereco_tabuleiro)
	}
		
	funcao logico temRepeticaoNaLinha(inteiro linha){
		para(inteiro i = 0; i < LINHAS; i++){
			para(inteiro j = 0; j < LINHAS; j++){
				se(i == j ou matriz[linha][i] == '#' ou matriz[linha][j] == '#' ou matriz[i][j] == 'e'){/*pula pro proximo*/}
				senao se(matriz[linha][i] == matriz[linha][j]){
					linha_com_erro = linha+1
					coluna_com_erro = j+1
					retorne verdadeiro
				}
			}
		}
		retorne falso
	}

	funcao logico temRepeticaoNaColuna(inteiro coluna){
		para(inteiro i = 0; i < COLUNAS; i++){
			para(inteiro j = 0; j < COLUNAS; j++){
				se(i == j ou matriz[i][coluna] == '#' ou matriz[j][coluna] == '#' ou matriz[i][j] == 'e'){/*pula pro proximo*/}
				senao se(matriz[i][coluna] == matriz[j][coluna]){
					linha_com_erro = j+1
					coluna_com_erro = coluna+1
					retorne verdadeiro
				}
			}
		}
		retorne falso
	}

	funcao inteiro determinaRegiao(inteiro linha, inteiro coluna){
		inteiro regiao = 0
		se(linha < 3){
			se(coluna < 3){
				regiao = 1
			}senao se(coluna >= 3 e coluna < 6){
				regiao = 2
			}senao{
				regiao = 3
			}
		}senao se(linha >=3 e linha < 6){
			se(coluna < 3){
				regiao = 4
			}senao se(coluna >= 3 e coluna < 6){
				regiao = 5
			}senao{
				regiao = 6
			}
		}senao{
			se(coluna < 3){
				regiao = 7
			}senao se(coluna >= 3 e coluna < 6){
				regiao = 8
			}senao{
				regiao = 9
			}
		}
		retorne regiao
	}
	
	funcao vazio populaRegiao(inteiro regiao){
		inteiro inicio_linha, inicio_coluna, limite_linha, limite_coluna
		se(regiao <= 3){
			inicio_linha = 0
			limite_linha = 3
		}senao se(regiao > 3 e regiao <= 6){
			inicio_linha = 3
			limite_linha = 6
		}senao{
			inicio_linha = 6
			limite_linha = 9
		}
		se(regiao == 1 ou regiao == 4 ou regiao == 7){
			inicio_coluna = 0
			limite_coluna = 3
		}senao se(regiao == 2 ou regiao == 5 ou regiao == 8){
			inicio_coluna = 3
			limite_coluna = 6
		}senao{
			inicio_coluna = 6
			limite_coluna = 9
		}

		inteiro a = 0
		inteiro b = 0
		para(inteiro i = inicio_linha; i < limite_linha; i++){	
			para(inteiro j = inicio_coluna; j < limite_coluna; j++){
				matriz3x3[a][b] = matriz[i][j]
				b++
			}
			b = 0
			a++
		}
	}

	/*
	 * Quando ocorre um erro de região, a matriz analisada é 3x3, 
	 * logo, ao informar a linha e a coluna com erro, esse número não passará de 3,
	 * portanto, é necessário compensar esse valor conforme a região
	*/
	funcao inteiro compensaLinhasDaRegiao(inteiro regiao){
		se(regiao <= 3)
			retorne 0
		senao se(regiao > 3 e regiao <= 6)
			retorne 3
		senao
			retorne 6
	}

	funcao inteiro compensaColunasDaRegiao(inteiro regiao){
		se(regiao == 1 ou regiao == 4 ou regiao == 7)
			retorne 0
		senao se(regiao == 2 ou regiao == 5 ou regiao == 8)
			retorne 3
		senao
			retorne 6
	}

	funcao logico temRepeticaoNaRegiao(inteiro linha, inteiro coluna){
		inteiro regiao = determinaRegiao(linha, coluna)
		populaRegiao(regiao)
		caracter aux
		para(inteiro i = 0; i < 3; i++){
			para(inteiro j = 0; j < 3; j++){
				aux = matriz3x3[j][i]
				se(aux == '#' ou aux == 'e'){/*nada*/}
				senao{
					para(inteiro m = 0; m < 3; m++){
						para(inteiro n = 0; n < 3; n++){
							se(matriz3x3[m][n] == '#' ou m == j ou n == i ou matriz[m][n] == 'e'){/*nada*/}
							senao se(aux == matriz3x3[m][n]){
								linha_com_erro = compensaLinhasDaRegiao(regiao)+j+1
								coluna_com_erro = compensaColunasDaRegiao(regiao)+i+1
								retorne verdadeiro
							}
						}
					}
				}
			}
		}
		retorne falso
	}

	funcao logico caracterEhValido(caracter c){
		para(inteiro i = 1; i < 10; i++){
			se(c == t.inteiro_para_caracter(i)){
				retorne verdadeiro
			}
		}
		se(c == '#')
			retorne verdadeiro
		retorne falso
	}	

	funcao vazio populaNumerosDados(){
		para(inteiro i = 0; i < LINHAS; i++){
			para(inteiro j = 0; j < COLUNAS; j++){
				numeros_dados[i][j] = matriz[i][j]
			}
		}
	}

	funcao logico ehNumeroDado(inteiro linha, inteiro coluna){
		se(numeros_dados[linha][coluna] == '#')
			retorne falso
		retorne verdadeiro
	}

	funcao logico temErros(){
		para(inteiro i = 0; i < LINHAS; i++){
			para(inteiro j = 0; j < COLUNAS; j++){
				se(temRepeticaoNaRegiao(i, j)){
					mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":REGION_WITH_REPEATED_VALUE"
					retorne verdadeiro
				}
			}
			se(temRepeticaoNaLinha(i)){
				mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":LINE_WITH_REPEATED_VALUE"
				retorne verdadeiro
			}
			se(temRepeticaoNaColuna(i)){
				mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":COLUMN_WITH_REPEATED_VALUE"
				retorne verdadeiro
			}
			para(inteiro j = 0; j < COLUNAS; j++){
				se(matriz[i][j] == 'e'){
					linha_com_erro = i+1
					coluna_com_erro = j+1
					mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":INVALID_VALUE_ON_THE_BOARD"
					retorne verdadeiro
				}
			}
			
		}
		retorne falso
	}

	/*
	 * Cópia da função temErros que não realiza a verificação de caracteres invalidos,
	 * pois só é preciso fazer essa validação na checagem do tabuleiro dado
	*/
	funcao logico temErrosSemInvalidos(){
		para(inteiro i = 0; i < LINHAS; i++){
			para(inteiro j = 0; j < COLUNAS; j++){
				se(temRepeticaoNaRegiao(i, j)){
					mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":REGION_WITH_REPEATED_VALUE"
					retorne verdadeiro
				}
			}
			se(temRepeticaoNaLinha(i)){
				mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":LINE_WITH_REPEATED_VALUE"
				retorne verdadeiro
			}
			se(temRepeticaoNaColuna(i)){
				mensagem_erro = linha_com_erro+"|"+coluna_com_erro+":COLUMN_WITH_REPEATED_VALUE"
				retorne verdadeiro
			}
		}
		retorne falso	
	}

	funcao vazio registraErrosNoResultado(){
		arq.escrever_linha(mensagem_erro, endereco_resultado)
		arq.fechar_arquivo(endereco_resultado)
	}

	funcao logico tabuleiroEstaCompleto(){
		para(inteiro i = 0; i < LINHAS; i++){
			para(inteiro j = 0; j < COLUNAS; j++){
				se(matriz[i][j] == '#')
					retorne falso
			}
		}
		retorne verdadeiro
	}

	funcao logico ganhou(){
		se(nao(temErrosSemInvalidos()) e tabuleiroEstaCompleto()){
			retorne verdadeiro
		}
		retorne falso
	}

	funcao vazio registraTabuleiroNoResultado(){
		para(inteiro i = 0; i < LINHAS; i++){
			cadeia linha = ""
			para(inteiro j = 0; j < COLUNAS; j++){
				caracter c = matriz[i][j]
				se(j == 8)
					linha += t.caracter_para_cadeia(c)
				senao
					linha += t.caracter_para_cadeia(c)+';'
			}
			arq.escrever_linha(linha, endereco_resultado)
		}
		arq.fechar_arquivo(endereco_resultado)
	}

	funcao vazio fimDeJogo(){
		//printaTabuleiro()
		//escreva("\nEncontre o tabuleiro resolvido no arquivo resultado.txt!\n")
		registraTabuleiroNoResultado()
	}

	funcao logico valor_eh_possivel(inteiro lin, inteiro col, caracter valor){
		caracter anterior = matriz[lin][col]
		matriz[lin][col] = valor
		logico erro_linha = temRepeticaoNaLinha(lin)
		logico erro_coluna = temRepeticaoNaColuna(col)
		logico erro_regiao = temRepeticaoNaRegiao(lin, col)
		matriz[lin][col] = anterior
		se(erro_linha){
			//escreva("\n", valor, " gerou erro de linha\n")
			retorne falso
		}senao se(erro_coluna){
			//escreva("\n", valor, " gerou erro de coluna\n")
			retorne falso
		}senao se(erro_regiao){
			//escreva("\n", valor, " gerou erro de região\n")
			retorne falso
		}
		retorne verdadeiro
	}

	funcao vazio printa_localizacao(cadeia msg){
		//escreva("\n[X: ", x, ";Y: ", y,"]\t", msg, "\n")
	}
	
	funcao vazio percorre_tabuleiro(logico avancar){  
		logico fim_linha = (y == 8)
		logico comeco_linha = (y == 0)
		se(avancar){
			se(nao(fim_linha)){
				y++
			}senao{
				y=0
				x++
			}
		}
		senao{//recua
			se(nao(comeco_linha)){
				y--
			}senao{
				y=8
				x--
			}
		}
	}

	funcao caracter valor_celula(inteiro lin, inteiro col){
		//marcelo++
		caracter jogada = matriz[lin][col]
		logico diferente_de_9 = jogada == '#' ou nao(jogada == '9')
		se(diferente_de_9){
			se(jogada == '#')
				jogada = '0'
			inteiro jogada_int = t.caracter_para_inteiro(jogada)
			para(inteiro i = jogada_int+1; i <= 9; i++){
				jogada = t.inteiro_para_caracter(i)
				se(valor_eh_possivel(lin, col, jogada))
					retorne jogada
			}	
		}
		jogada = '#'
		retorne jogada
	}	
	
	funcao vazio soluciona(inteiro lin, inteiro col){
		printa_localizacao("")
		se(ganhou()){
			fimDeJogo()
			retorne
		}
		matriz[x][y] = valor_celula(lin, col)
		se(x == 8 e y == 8){
			printaTabuleiro()
		}
		senao se(matriz[x][y] == '#'){
			faca{percorre_tabuleiro(falso)} enquanto(ehNumeroDado(x, y))
		}senao{
			faca{
				percorre_tabuleiro(verdadeiro)
			} enquanto(ehNumeroDado(x, y) e nao(x == 8 e y == 8))
		}
		soluciona(x, y)
	}	

	funcao vazio printa_linha(inteiro l, cadeia msg){
		escreva(msg,"\n")
		para(inteiro i = 0; i < LINHAS; i++){
			escreva("\t",matriz[l][i])
		}
		escreva("\n")
	}
	
	funcao inicio(){
		setup()
		se(temErros() ou nao(mensagem_erro == "")){
			escreva("Falha na execução do jogo.\nLeia o arquivo resultado.txt para mais detalhes.\n",mensagem_erro, "\n")
			registraErrosNoResultado()
		}
		senao{
			//escreva("TABULEIRO RECEBIDO: \n\n")
			//printaTabuleiro()
			//escreva("\n")
			se(ganhou()){
				escreva("TABULEIRO RESOLVIDO: \n\n")
				fimDeJogo()
			}senao{
				se(ehNumeroDado(x, y)){
					faca{
						percorre_tabuleiro(verdadeiro)	
					}enquanto(ehNumeroDado(x, y))
				}
				//escreva("\nTABULEIRO RESOLVIDO: \n\n")
				soluciona(x, y)
				//escreva("RODEI ", marcelo, " VEZES!")
			}
		}
	}
	
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 1133; 
 * @DOBRAMENTO-CODIGO = [54, 100, 130, 170, 179, 188, 213, 224, 271, 354];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */