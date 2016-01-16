
## ClipClapCharge Framework  para iOS##

ClipClap te permite incorporar la acción de pagar en tu aplicación iOS de forma fácil y rápida. Solo debes agregar el framework que te brindamos y los pagos serán gestionados por la aplicación Billetera de ClipClap.
Te recordamos que para poder hacer de esta integración debes descargar la aplicación de Billetera ClipClap en la AppStore.

## Prerrequisitos ##

 1. ***Tener una cuenta ClipClap Datáfono:***
Para poder realizar la integración con ClipClap debes primero tener una cuenta en ClipClap Datáfono, puedes hacer el proceso de registro siguiendo este [link](https://clipclap.co/) o desde la misma aplicación.

 2. ***Tener el secretKey de tu negocio:***
Una vez tengas tu usuario Datáfono, tendrás que tener a la mano el “secreKey” de tu negocio, puedes consultar los pasos para adquirirlos en detalle [aquí](https://clipclap.co/).

 3. **ClipClap Billetera para tus clientes:**
Para que tus usuarios puedan acceder al evento de pago de ClipClap deben tener instalada la aplicación Billetera, esta permitirá realizar los pagos de forma rápida y segura para tus clientes.

 4. ***Entorno de Prueba y Entorno de Producción:***
Recuerda que puedes cambiar entre entorno de prueba y de producción, para llevar un mayor control de tu integración. puedes aprender cómo hacerlo en el siguiente [link](https://clipclap.co/).


## Integración ##

Sigue los siguientes pasos para conocer cómo se debe integrar el framework de pago ClipClap en tu aplicación iOS con Xcode 7 o superior:

**Paso 1: En el proyecto de Xcode de tu aplicación integra el framework así:**


![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_6.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_7.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_8.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_9.png)


**Paso 2: Configurar el cobro.**

En el app delegate de su aplicación coloque este método si va a usar Universal Links en ***iOS 9 o superior***:

    #import <ClipClapCharge/ClipClapCharge.h>

    -(BOOL) application:(UIApplication *)application 
				  continueUserActivity:(nonnull NSUserActivity *)userActivity 
		    restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler {
    
	    NSURL *url = userActivity.webpageURL;
	    
    	if ([[CCBilleteraPayment shareInstance] handleURL:url sourceApplication:nil])
		{
			return YES;
		}
    		
    	return NO;										
	}

En el app delegate de su aplicación coloque este método si va a usar URLScheme en ***iOS 9 o superior***:

    #import <ClipClapCharge/ClipClapCharge.h>
    
    -(BOOL)application:(UIApplication *)app 
								    openURL:(NSURL *)url options:(NSDictionary *)options {
    
    	if ([[CCBilleteraPayment shareInstance] handleURL:url 
    	sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]])
		{
			return YES;
		}
    		
    	return NO;										
	}

> ***Nota:*** Por experiencia de usuario no es recomendable usar URL Scheme en iOS 9 o superior ya que cuando ClipClap Billetera intente abrir su aplicación una vez realizado el pago ésta no se abrirá automáticamente.

En el app delegate de su aplicación coloque este método en ***iOS 8.4.1 o anterior***:

    #import <ClipClapCharge/ClipClapCharge.h>
    
	-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
			sourceApplication:(NSString *)sourceApplication annotation:(id)annotation  {
    
    	if ([[CCBilleteraPayment shareInstance] handleURL:url 
    	sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]])
		{
			return YES;
		}
    		
    	return NO;										
	}

Importa el `.h` en la clase donde vas a usar ClipClapCharge framework:

    #import <ClipClapCharge/ClipClapCharge.h>
    
Con la llave secreta que obtienes abriendo una cuenta ClipClap Datáfano:

    [CCBilleteraPayment shareInstance].secretkey = @"Your_Secret_Key";

Para borrar los Productos de un cobro previo: ***(Altamente recomendable cuando haga un cobro nuevo)***

    [[CCBilleteraPayment shareInstance] resetItems];

Para obtener respuesta de la aplicación ClipClap Billetera cuando el cobro se haya realizado (iOS 9 o superior):
    
    [CCBilleteraPayment shareInstance].universalLinlCallback = @"Your_Universal_Link"://;

Para obtener respuesta de la aplicación ClipClap Billetera cuando el cobro se haya realizado (iOS 8.4.1 o anterior):
 
    [CCBilleteraPayment shareInstance].urlSchemeCallback = @"Your_URL_Scheme";

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

> ***Nota:*** Estas dos formas de crear el cobro son mutuamente excluyentes. Si usted utiliza ambas formas al mismo tiempo, la *forma 'total-impuesto-tip'* prevalece sobre la *forma 'producto-por-producto'*.

> ***Nota:*** Si en su cuenta de ClipClap Datáfono tiene lo opción de propina deshabilitada, la opción de pagar con propina en ClipClap Billetera NO aparecerá*.

**Paso 3: Decirle a ClipClap Billetera que realice el cobro**

    //Obteniendo de ClipClap un token único para este cobro. Hasta este momento todavía el cobro no se ha hecho efectivo.
    [[CCBilleteraPayment shareInstance] 
							 getPaymentTokenWithBlock:^(NSString *token, NSError *error){    
        if (error)
        {
            //Aqui debe mostrarse al usuario que hubo problemas para realizar el pago.
        }
        else
        {
            //Antes de hacer efectivo el cobro con el 'token' obtenido usted debe guardar
            //éste en su sistema de información.
            
            //Luego de que haya guardado el ´token´ se procede llamar a ClipClap Billetera
            //para que gestione el cobro.
             [[CCBilleteraPayment shareInstance] commitPaymentWithToken:token 
									          andBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    //Mostrar al usuario que el pago se realizó con éxito.
                }
                else
                {
                    if (error.code == kCCBilleteraPaymentErrorTypeRejected)
                    {
	                    //Mostrar al usuario que el pago fue rechazado
                    }
                    else if (error.code == kCCBilleteraPaymentErrorTypeRejected)
                    {
	                    //error.userInfo[@"error"] contiene la razón del fallo del pago.
	                    //Mostrar al usuario que hubo un error realizando el pago.
                    }
                }
            }];
        }
    }];

> ***IMPORTANTE:*** Es recomendable guardar el 'token' ya que con éste usted puede relacionar el cobro con su sistema de información.


## Tipos de impuesto ##

    kCCBilleteraTaxTypeIVARegular => IVA Regular del 16%
    kCCBilleteraTaxTypeIVAReducido => IVA Reducido del 5%
    kCCBilleteraTaxTypeIVAExcento => IVA Excento del 0%
    kCCBilleteraTaxTypeIVAExcluido => IVA Excluido del 0%
    kCCBilleteraTaxTypeConsumoRegular => Consumo Regular 8%
    kCCBilleteraTaxTypeConsumoReducido => Consumo Reducido 4%
    kCCBilleteraTaxTypeIVAAmpliado => IVA Ampliado 20%

## Tipos de error ##

    kCCBilleteraPaymentErrorTypeRejected => El cliente rechazó el pago.
    kCCBilleteraPaymentErrorTypeFailed => El cliente intentó pagar pero hubo en error