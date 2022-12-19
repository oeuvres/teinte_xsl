<?php declare(strict_types=1);

/**
 * Part of Teinte https://github.com/oeuvres/teinte_php
 * Copyright (c) 2020 frederic.glorieux@fictif.org
 * Copyright (c) 2013 frederic.glorieux@fictif.org & LABEX OBVIL
 * Copyright (c) 2012 frederic.glorieux@fictif.org
 * BSD-3-Clause https://opensource.org/licenses/BSD-3-Clause
 */
namespace Oeuvres\Xsl;

class Tpack
{
    /** Where it’s place here */
    static protected string $dir;
    /**
     * Initialize static variable
     */
    static public function init()
    {
        self::$dir = __DIR__ . DIRECTORY_SEPARATOR;
    }
}
Tpack::init();
