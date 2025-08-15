<?php

use Facebook\WebDriver\Remote\RemoteWebDriver;
use Facebook\WebDriver\Remote\DesiredCapabilities;
use Facebook\WebDriver\WebDriverBy;
use Facebook\WebDriver\WebDriverKeys;
use Facebook\WebDriver\Exception\NoSuchElementException;
use GuzzleHttp\Client;

class VkAuthController
{
    private function solveCaptcha($imageBase64, $apiKey)
    {
        $client = new \GuzzleHttp\Client();

        $response = $client->request('POST', 'http://2captcha.com/in.php', [
            'form_params' => [
                'method' => 'base64',
                'key' => $apiKey,
                'body' => $imageBase64,
                'json' => 1,
            ],
        ]);

        $result = json_decode($response->getBody(), true);
        if ($result['status'] != 1) {
            throw new Exception("2Captcha error: " . $result['request']);
        }

        $captchaId = $result['request'];

        sleep(15);

        for ($i = 0; $i < 10; $i++) {
            $response = $client->get('http://2captcha.com/res.php', [
                'query' => [
                    'key' => $apiKey,
                    'action' => 'get',
                    'id' => $captchaId,
                    'json' => 1,
                ]
            ]);

            $result = json_decode($response->getBody(), true);
            if ($result['status'] == 1) {
                return $result['request'];
            }

            sleep(5);
        }

        throw new Exception("Captcha not solved in time");
    }

    public function actionTest()
    {
        $login = 'phone';
        $password = 'password';
        $twoFactorCode = 'code';

        $serverUrl = 'http://localhost:4444';
        $driver = RemoteWebDriver::create($serverUrl, DesiredCapabilities::chrome());

        try {
            $driver->get('https://oauth.vk.com/authorize?client_id=6287487&scope=1073737727&redirect_uri=https://oauth.vk.com/blank.html&display=page&response_type=token&revoke=1');

            $login_box = $driver->findElement(WebDriverBy::name('email'));
            $login_box->sendKeys($login);

            $password_box = $driver->findElement(WebDriverBy::name('pass'));
            $password_box->sendKeys($password);
            $password_box->sendKeys(WebDriverKeys::ENTER);

sleep(3);

try {
    $captchaImg = $driver->findElement(WebDriverBy::cssSelector('img[src*="captcha"]'));
    $src = $captchaImg->getAttribute('src');

    $image = file_get_contents($src);
    $imageBase64 = base64_encode($image);

    $captchaText = $this->solveCaptcha($imageBase64, '1ce062298a0da1edbd3fd6c1dd821dd5');

    try {
        $captchaInput = $driver->findElement(WebDriverBy::name('captcha_key'));
    } catch (NoSuchElementException $e) {
        try {
            $captchaInput = $driver->findElement(WebDriverBy::name('captcha'));
        } catch (NoSuchElementException $e) {
            $captchaInput = $driver->findElement(WebDriverBy::cssSelector('input[name*="captcha"]'));
        }
    }
    $captchaInput->sendKeys($captchaText);

    $submit_button = $driver->findElement(WebDriverBy::cssSelector('button[type="submit"], input[type="submit"]'));
    $submit_button->click();

    sleep(3);
} catch (NoSuchElementException $e) {
}



            $currentUrl = mb_strtolower($driver->getCurrentURL());

            if (str_contains($currentUrl, "act=authcheck") or str_contains($currentUrl, "act=security_check")) {
                if ($twoFactorCode) {
                    $code_box = $driver->findElement(WebDriverBy::name('code'));
                    $code_box->sendKeys($twoFactorCode);

                    $submit_button = $driver->findElement(WebDriverBy::xpath("//input[@class='button' and @type='submit']"));
                    $submit_button->click();

                    sleep(3);
                } else {
                    echo "Требуется код двухфакторной аутентификации. Пожалуйста, введите его:" . PHP_EOL;
                    $driver->quit();
                    return ExitCode::NOINPUT;
                }
            }

            $currentUrl = mb_strtolower($driver->getCurrentURL());
            if (str_contains($currentUrl, "oauth.vk.com")) {
                $allow_button = $driver->findElement(WebDriverBy::xpath("//button[contains(@class, 'flat_button') and contains(text(), 'Разрешить')]"));
                $allow_button->click();

                sleep(5);

                $currentUrl = ($driver->getCurrentURL());
                if (str_contains($currentUrl, "access_token")) {
                    $token = explode("&", explode("access_token=", $currentUrl)[1])[0];
                    echo "токен: $token" . PHP_EOL;
                    return ExitCode::OK;
                } else {
                    echo "токен: none" . PHP_EOL;
                    return ExitCode::DATAERR;
                }
            }
        } catch (Exception $exception) {
            echo $exception->getMessage() . PHP_EOL;
            var_dump($driver->getPageSource());
            return ExitCode::UNSPECIFIED_ERROR;
        } finally {
            $driver->quit();
        }


        var_dump($driver-getPageSource());
        sleep(5);
        $driver-quit();

        return ExitCode::OK;
    }
}
