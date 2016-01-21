
## ClipClapCharge Framework  para iOS##

ClipClap te permite incorporar la acciÃ³n de pagar en tu aplicaciÃ³n iOS de forma fÃ¡cil y rÃ¡pida. Solo debes agregar el framework que te brindamos y los pagos serÃ¡n gestionados por la aplicaciÃ³n Billetera de ClipClap.
Te recordamos que para poder hacer de esta integraciÃ³n debes descargar la aplicaciÃ³n de Billetera ClipClap en la AppStore.

## Prerrequisitos ##

 1. ***Tener una cuenta ClipClap DatÃ¡fono:***
Para poder realizar la integraciÃ³n con ClipClap debes primero tener una cuenta en ClipClap DatÃ¡fono, puedes hacer el proceso de registro siguiendo este [link](https://clipclap.co/) o desde la misma aplicaciÃ³n.

 2. ***Tener el secretKey de tu negocio:***
Una vez tengas tu usuario DatÃ¡fono, tendrÃ¡s que tener a la mano el â€œsecreKeyâ€ de tu negocio, puedes consultar los pasos para adquirirlos en detalle [aquÃ­](https://clipclap.co/).

 3. **ClipClap Billetera para tus clientes:**
Para que tus usuarios puedan acceder al evento de pago de ClipClap deben tener instalada la aplicaciÃ³n Billetera, esta permitirÃ¡ realizar los pagos de forma rÃ¡pida y segura para tus clientes.

 4. ***Entorno de Prueba y Entorno de ProducciÃ³n:***
Recuerda que puedes cambiar entre entorno de prueba y de producciÃ³n, para llevar un mayor control de tu integraciÃ³n. puedes aprender cÃ³mo hacerlo en el siguiente [link](https://clipclap.co/).


## IntegraciÃ³n ##

Sigue los siguientes pasos para conocer cÃ³mo se debe integrar el framework de pago ClipClap en tu aplicaciÃ³n iOS con Xcode 7 o superior:

**Paso 1: En el proyecto de Xcode de tu aplicaciÃ³n integra el framework asÃ­:**


![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_6.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_7.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_8.png)

![enter image description here](http://www.clipclap.co/docs/tutorials/ios/images/slide_9.png)

**Paso 1.1: Para que ClipClapCharge.framework pueda saber si ClipClap Billetera estÃ¡ instalada en su dispositivo. (solo iOS 9 o superior)**

En en el "*info.plist*" de su aplicaciÃ³n agregue:

    <key>LSApplicationQueriesSchemes</key>
	<array>
		<string>ClipClapBilletera</string>
	</array>

> ***IMPORTANTE:*** En iOS 9 o superior es necesario colocar el URL Scheme de ClipClap Billetera en la lista blanca de Scheme de su aplicaciÃ³n, de lo contrario ClipClap Billetera no se abrirÃ¡.

**Paso 2: Configurar tu llave secreta y  el callback de tu aplicaciÃ³n.**

En el app delegate de su aplicaciÃ³n coloque:

    #import <ClipClapCharge/CCBPaymentHandler.h>
	.
    .
    .
    -(BOOL) application:(UIApplication *)application 
						    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
		
		//Con la llave secreta que obtienes abriendo una cuenta ClipClap DatÃ¡fano: 
		[CCBPaymentHandler shareInstance].secretkey = @"YOUR_SECRET_KEY";
		
		//Tu 'Universal link' Ã³ 'URL Scheme'
		[CCBPaymentHandler shareInstance].urlSchemeOrUniversalLinkCallback = "YOUR_SCHEME";
		
		return YES;
	}

Si va a usar Universal Links en ***iOS 9 o superior***:

    -(BOOL) application:(UIApplication *)application 
				  continueUserActivity:(nonnull NSUserActivity *)userActivity 
		    restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler {

	    NSURL *url = userActivity.webpageURL;	    
    	BOOL didClipClapBilleteraHandle = [[CCBPaymentHandler shareInstance] 
													handleURL:url
				                            sourceApplication:nil
                           andSuccessfulWhenKilledBlock:^(BOOL succeeded, NSError *error){
	        if (succeeded)
	        {
	            //Mostrar mensaje de pago exitoso al usuario.
	        }
	        else
	        {
	            //Mostrar mensaje de error del pago al usuario.
	        }
	    }];
    
	    return didClipClapBilleteraHandle;										
	}

Si va a usar URLScheme en ***iOS 9 o superior***:
    
    -(BOOL)application:(UIApplication *)app openURL:(NSURL *)url 
													     options:(NSDictionary *)options {
    
		BOOL didClipClapBilleteraHandle = [[CCBPaymentHandler shareInstance] 
						handleURL:url
				sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]            
							andSuccessfulWhenKilledBlock:^(BOOL succeeded, NSError *error){
	        if (succeeded)
	        {
	            //Mostrar mensaje de pago exitoso al usuario.
	        }
	        else
	        {
	            //Mostrar mensaje de error del pago al usuario.
	        }
	    }];
    
	    return didClipClapBilleteraHandle;									
	}

> ***Nota:*** Por experiencia de usuario no es recomendable usar URL Scheme en iOS 9 o superior ya que cuando ClipClap Billetera intente abrir su aplicaciÃ³n una vez realizado el pago Ã©sta no se abrirÃ¡ automÃ¡ticamente.

Si va a dar soporte a  ***iOS 8.x.x***:
    
	-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
			sourceApplication:(NSString *)sourceApplication annotation:(id)annotation  {
    
    	BOOL didClipClapBilleteraHandle = [[CCBPaymentHandler shareInstance] 										
											   handleURL:(NSURL *)url
							           sourceApplication:sourceApplication
							andSuccessfulWhenKilledBlock:^(BOOL succeeded, NSError *error){
	        if (succeeded)
	        {
	            //Mostrar mensaje de pago exitoso al usuario.
	        }
	        else
	        {
	            //Mostrar mensaje de error del pago al usuario.
	        }
	    }];
    
	    return didClipClapBilleteraHandle;										
	}

> ***Nota:*** En todas la opciones expuestas anteriormente el bloque 'andSuccessfulWhenKilledBlock' serÃ¡ ejecutado sÃ³lo si su aplicaciÃ³n fue cerrada por el sistema operativo iOS.

**Paso 3: Configurar el cobro.**

En  la clase donde vas a usar ClipClapCharge framework:

    #import <ClipClapCharge/CCBPaymentHandler.h>
    #import <ClipClapCharge/CCBPayment.h>
    
Hay dos forma de crear un cobro para que ClipClap Billetera lo gestione:

 1) *Forma 'producto por producto':* Esta opciÃ³n permite agregar al cobro productos de forma individual especificando su nombre, precio, cantidad y el impuesto que se le aplica al producto. AsÃ­: 
    
    //Creando un objeto CCBPayment
    CCBPayment *cobro = [[CCBPayment alloc] init];
    
    //Para cada producto haga esto:
    NSString *nombreProducto = @"Camisa Polo";
    int precio = 25000;
    int cantidad = 3;
      
    [cobro addItemWithName:nombreProducto 
					 value:precio 
					 count:cantidad  
		       andTaxType:kCCBilleteraTaxTypeIVARegular];

2) *Forma 'total-impuesto-propina':* Esta opciÃ³n permite definir el total a cobrar de forma inmediata especificando el total a cobrar sin impuestos, el impuesto sobre el total y de forma opcional la propina. AsÃ­:

    //Creando un objeto CCBPayment
    CCBPayment *cobro = [[CCBPayment alloc] init];
    
    NSString *descripciÃ³n = @"Dos perros calientes y una gaseosa";
    int totalSinImpuesto = 20000;
    int impuesto = 1600; //Se aplicÃ³ Consumo Regular del 8% sobre el total sin impuesto.
    int propina = 2000 //Esto es opcional.
    
    //Use este mÃ©todo para NO incluir propina.
    [cobro addTotalWithValue:totalSinImpuesto
                         tax:impuesto
              andDescription:descripciÃ³n];
                                           
    //Use este mÃ©todo para SI incluir propina.
    [cobro addTotalWithValue:totalSinImpuesto
                         tax:impuesto
                         tip:propina
              andDescription:descripciÃ³n];

> ***Nota:*** Estas dos formas de crear el cobro son mutuamente excluyentes. Si usted utiliza ambas formas al mismo tiempo, la *forma 'total-impuesto-tip'* prevalece sobre la *forma 'producto-por-producto'*.

> ***Nota:*** Si en su cuenta de ClipClap DatÃ¡fono tiene lo opciÃ³n de propina deshabilitada, la opciÃ³n de pagar con propina en ClipClap Billetera NO aparecerÃ¡*.

**Paso 4: Decirle a ClipClap Billetera que realice el cobro**

    //Obteniendo de ClipClap un token Ãºnico para este cobro. Hasta este momento todavÃ­a el cobro no se ha hecho efectivo.
    [[CCBPaymentHandler shareInstance] 
							 getPaymentTokenWithBlock:^(NSString *token, NSError *error){    
        if (error)
        {
            //Aqui debe mostrarse al usuario que hubo problemas para realizar el pago.
        }
        else
        {
            //Antes de hacer efectivo el cobro con el 'token' obtenido usted debe guardar
            //Ã©ste en su sistema de informaciÃ³n.
            
            //Luego de que haya guardado el Â´tokenÂ´ se procede llamar a ClipClap Billetera
            //para que gestione el cobro.
             [[CCBPaymentHandler shareInstance] commitPaymentWithToken:token 
									          andBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    //Mostrar al usuario que el pago se realizÃ³ con Ã©xito.
                }
                else
                {
                    if (error.code == kCCBilleteraPaymentErrorTypeRejected)
                    {
	                    //Mostrar al usuario que el pago fue rechazado
                    }
                    else if (error.code == kCCBilleteraPaymentErrorTypeRejected)
                    {
	                    //error.userInfo[@"error"] contiene la razÃ³n del fallo del pago.
	                    //Mostrar al usuario que hubo un error realizando el pago.
                    }
                }
            }];
        }
    }];

> ***IMPORTANTE:*** Es recomendable guardar el 'token' ya que con Ã©ste usted puede relacionar el cobro con su sistema de informaciÃ³n.


## Tipos de impuesto ##

    kCCBilleteraTaxTypeIVARegular => IVA Regular del 16%.
    kCCBilleteraTaxTypeIVAReducido => IVA Reducido del 5%.
    kCCBilleteraTaxTypeIVAExcento => IVA Excento del 0%.
    kCCBilleteraTaxTypeIVAExcluido => IVA Excluido del 0%.
    kCCBilleteraTaxTypeConsumoRegular => Consumo Regular 8%.
    kCCBilleteraTaxTypeConsumoReducido => Consumo Reducido 4%.
    kCCBilleteraTaxTypeIVAAmpliado => IVA Ampliado 20%.

## Tipos de error ##

    kCCBilleteraPaymentErrorTypeRejected => El cliente rechazÃ³ el pago.
    kCCBilleteraPaymentErrorTypeFailed => El cliente intentÃ³ pagar pero hubo en error.
