
## ClipClapCharge Framework  para iOS##

ClipClap te permite incorporar la acción de pagar en tu aplicación iOS de forma fácil y rápida. Solo debes agregar el framework que te brindamos y los pagos serán gestionados por la aplicación Billetera de ClipClap.
Te recordamos que para poder hacer de esta integración debes descargar la aplicación de Billetera ClipClap en la AppStore.

Sigue los siguientes pasos para conocer cómo se debe integrar el framework de pago ClipClap en tu aplicación iOS:

**Paso 1: En el proyecto de xcode de tu aplicación integra el framework así:**


![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_6.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_7.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_8.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_9.png)


**Paso 2: Configurar el cobro.**

Importa el `.h` en la clase donde vas a user ClipClapCharge framework:

    #import <ClipClapCharge/ClipClapCharge.h>
    
Con la llave secreta que obtienes abriendo una cuenta ClipClap Datáfano:

    [CCBilleteraPayment shareInstance].secretkey = @"Your Secret Key";

Para obtener respuesta de la aplicación ClipClap Billetera cuando el cobro se haya realizado (iOS 9 o superior):
    
    [CCBilleteraPayment shareInstance].universalLinlCallback = @"Your Universal Link"://;

Para obtener respuesta de la aplicación ClipClap Billetera cuando el cobro se haya realizado (iOS 8.4.1 o anterior):
 
    [CCBilleteraPayment shareInstance].urlSchemeCallback = @"Your URL Scheme";

Hay dos forma de crear un cobro para que ClipClap Billetera lo gestione:

 1) *Forma 'producto por producto':* Esta opción permite agregar al cobro productos de forma individual especificando su nombre, precio, cantidad y el impuesto que se le aplica al producto. Así: 
    
    //Por cada producto haga esto:
    NSString *nombreProducto = @"Camisa Polo";
    int precio = 25000;
    int cantidad = 3;
      
    [[CCBilleteraPayment shareInstance] addItemWithName:nombreProducto
												  value:precio 
												  count:cantidad  
											 andTaxType:kCCBilleteraTaxTypeIVARegular];

2) *Forma 'total-impuesto-propina':* Esta opción permite definir el total a cobrar de forma inmediata especificando el total a cobrar sin impuestos, el impuesto sobre el total y de forma opcional la propina. Así:

    NSString *descripción = @"Dos perros calientes y una gaseosa";
    int totalSinImpuesto = 20000;
    int impuesto = 1600; //Se aplicó Consumo Regular del 8% sobre el total sin impuesto.
    int propina = 2000 //Esto es opcional.
    
    //Use este método para NO incluir propina.
    [[CCBilleteraPayment shareInstance] addTotalWithValue:totalSinImpuesto
                                                      tax:impuesto
                                           andDescription:descripción];
                                           
    //Use este método para SI incluir propina.
    [[CCBilleteraPayment shareInstance] addTotalWithValue:totalSinImpuesto
                                                      tax:impuesto
                                                      tip:propina
                                           andDescription:descripción];

> ***Nota:*** Estas dos formas de crear el cobro son mutuamente excluyentes.

**Paso 3: Decirle a ClipClap Billetera que realice el cobro**

    //Obteniendo de ClipClap un token único para este cobro. Hasta este momento todavía el cobro no se ha hecho efectivo.
    [[CCBilleteraPayment shareInstance] getPaymentTokenWithBlock:^(NSString *token, NSError *error) {
        
        if (error)
        {
            //Aqui debe mostrarse al usuario que hubo problemas para realizar el pago.
        }
        else
        {
            //Antes de hacer efectivo el cobro con el 'token' obtenido usted debe guardar
            //este ´token´ en su sistema de información.
            
            //Luego de que haya guardado el ´token´ se procede llamar a ClipClap Billetera
            //para que gestione el cobro.
            [[CCBilleteraPayment shareInstance] commitPaymentWithToken:token];
        }
    }];

> ***IMPORTANTE:*** Si al momento de guardar el ´token´ en su sistema de información falla, no convoque a ClipClap Billetera para que gestione el pago.


## Tipos de impuesto ##

    kCCBilleteraTaxTypeIVARegular => IVA Regular del 16%
    kCCBilleteraTaxTypeIVAReducido => IVA Reducido del 5%
    kCCBilleteraTaxTypeIVAExcento => IVA 0%
    kCCBilleteraTaxTypeIVAExcluido => IVA 0%
    kCCBilleteraTaxTypeConsumoRegular => Consumo Regular 8%
    kCCBilleteraTaxTypeConsumoReducido => Consumo Reducido 4%
    kCCBilleteraTaxTypeIVAAmpliado => IVA Ampliado 20%

## Respuesta por parte de ClipClap Billetera ##

Cuando ClipClap Billetera a ha finalizado el cobro, este responde de tres maneras a la aplicación que solicitó sus servicios. Así:

***Para iOS 9 o superior:***

Si el cobro se realizó exitosamente:

    "Your universal linking?response=ok"

Si el cobro fue rechazado por el cliente:
  
    "Your universal linking?response=cancel" //El cobro fue rechazado por el cliente.

Si hubo un error realizando el cobro:

    "Your universal linking?response=error&message=Mostrar este error en tu aplicación iOS"

***Para iOS 8.4.1 o anterior***

Si el cobro se realizó exitosamente:

    "Your URL Scheme://?response=ok"

Si el cobro fue rechazado por el cliente:
  
    "Your URL Scheme://?response=cancel" //El cobro fue rechazado por el cliente.

Si hubo un error realizando el cobro:

    "Your URL Scheme://?response=error&message=Mostrar este error en tu aplicación iOS"




