Este projeto foi criado com Xcode 11, Swift 5

Inicialmente foi adicionado o podfile, juntamente com o framework Alamofire.

Depois troquei o target device para ios 11, pois o app ficará compatível com a maioria dos aparelhos atualmente. Para isso, tive que tirar o gerenciamento de Scenes, usado a partir do iOS 13.

Alterei a linguagem padrão do projeto para português brasileiro.

Ainda no info.plist, adicionei Strings necessárias para indicar o uso de localização (GPS) do aparelho.

Incluí uma classe de serviços de localização, já desenvolvida anteriormente, para tratar permissões referentes ao uso do GPS.

Foram incluídos também extensões para personalização de cantos arredondados em UIViews, e componente de Alert. 

Um arquivo foi criado para separar chaves de APIs, deixando o código facilmente configurável.

Usando imagens gratuitas de uma base de imagens, criei um ícone para o app usando o Sketch.

Ajustei também outros ícones para usar na previsão do tempo no app. 

A termos de layout, foram escolhidas algumas informações disponibilizadas pela API Dark Sky para montar o layout do aplicativo. Nem todas os dados disponibilizados pela API foram usados, mas a ideia de usar mais informações é a mesma.

Para exemplificar diferentes formas de elaboração do app, foram montadas interfaces com itens dinâmicos (previsões por hora e por dias) e itens estáticos (previsão do momento e detalhes da previsão). 

Na previsão por hora, foi criada uma View para ser reutilizada e inserida dentro de um StackView.

Na previsão semanal, foi usada uma Collection. Nela, também podemos clicar e seguir para uma segunda tela onde há mais informações sobre o clima do dia.

Adicionei um botão de refresh na data/hora da informação obtida, no topo do app. O refresh faz uma nova requisição na API, mostrando os dados atualizados.

Seguindo a documentação da API Dark Sky, temos algumas diretrizes para o response da API. Uma delas é que se o atributo “darksky-unavailable” estiver presente, então não há previsão para aquela localidade. Foi feito tratamento de erro nesse caso.

No ViewController principal, eu separei o código referente ao LocationManager em outro arquivo, diminuindo a quantidade de código no ViewController.

Ao contrário do LocationManager, eu deixei o código da extensão do CollectionView no próprio arquivo do ViewController, mostrando que também é possível fazer dessa forma, e algumas vezes se torna até mais simples.

Foi criada uma tela no estilo modal para exibir detalhes da previsão ao clicar num dia específico. Para fechar o modal, o usuário pode clicar no botão Voltar, ou arrastar o dedo de cima ou para baixo. Nessa caso, o modal foi usado para exemplificar o controle de gestos e também o uso de transição simples. 

Foi adicionado também uma animação no ícone do clima para chamar atenção do usuário.

Foi definido também o texto em Strings de internacionalização para caso o app seja internacionalizado no futuro strings de internacionalização. Apesar de que ainda seria necessário trabalhar com o idioma da API e também traduzir strings do storyboard e info.plist.

Ao terminar, notei que eu deveria ter feito o collectionView no lugar do StackView e vice-versa, pois o número de previsão para os próximos dias é bem menos que o das próximas horas, deixando espaço em branco em telas maiores. Se eu tivesse invertido, seria mais fácil preencher toda a largura da tela com espaçamento entre os itens do stackview.

Finalmente, o app foi testado num aparelho real. Para colocar o app na Apple Store, basicamente precisamos definir uma conta de desenvolvedor Apple e submeter para aprovação.

