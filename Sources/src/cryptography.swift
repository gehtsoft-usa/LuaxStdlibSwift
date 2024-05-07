import Foundation
import CommonCrypto
import DataDeflate

public typealias cryptography = Cryptography

public enum CryptographyError: Error {
    case composingError
}

enum AESError: Error {
    case KeyError((String, Int))
    case IVError((String, Int))
    case CryptorError((String, Int))
}

//@DocBrief("The platform cryptography functions")
public class Cryptography: NSObject {
    public static func MD5(_ v : buffer?) throws -> buffer? {
        guard let v = v else { return nil }

        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        let _ = v.data.withUnsafeBytes { pointer in
            CC_MD5(pointer.baseAddress, CC_LONG(v.length()), &digest)
        }
        var md5String = ""
        for byte in digest {
            md5String += String(format:"%02x", UInt8(byte))
        }
        do {
            return try buffer.fromHexString(md5String)
        } catch {
            throw CryptographyError.composingError
        }
    }

    public static func SHA1(_ v : buffer?) throws -> buffer? {
        guard let v = v else { return nil }

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let _ = v.data.withUnsafeBytes { pointer in
            CC_SHA1(pointer.baseAddress, CC_LONG(v.length()), &digest)
        }
        var sha1String = ""
        for byte in digest {
            sha1String += String(format:"%02x", UInt8(byte))
        }
        do {
            return try buffer.fromHexString(sha1String)
        } catch {
            throw CryptographyError.composingError
        }
    }

    public static func SHA256(_ v : buffer?) -> buffer? {
        fatalError("'SHA256' is not implemented yet.");
    }

    public static func SHA512(_ v : buffer?) -> buffer? {
        fatalError("'SHA512' is not implemented yet.");
    }

    private static func aesCBCDecrypt(data:Data, keyData:Data) throws -> Data? {
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128]
        if !validKeyLengths.contains(keyLength) {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }

        let dataLength = size_t(data.count)
        var resultData = Data(count: dataLength)

        var numBytesDecrypted :size_t = 0
        let options = CCOptions(kCCOptionPKCS7Padding)
        let ivBuffer = Data(repeating: 0, count: 16)

        let cryptStatus = resultData.withUnsafeMutableBytes {(cryptBytes: UnsafeMutableRawBufferPointer) in
            data.withUnsafeBytes {(dataBytes: UnsafeRawBufferPointer) in
                keyData.withUnsafeBytes {(keyBytes: UnsafeRawBufferPointer) in
                    ivBuffer.withUnsafeBytes {(ivBytes: UnsafeRawBufferPointer) in
                        CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            options,
                            keyBytes.baseAddress, keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, dataLength,
                            cryptBytes.baseAddress, dataLength,
                            &numBytesDecrypted)
                    }
                }
            }
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            resultData.count = numBytesDecrypted
        }
        else {
            throw AESError.CryptorError(("Decryption failed", Int(cryptStatus)))
        }
        
        return resultData;
    }
    
    public static func AES128(_ v : buffer?, _ key : buffer?, _ doEncryption: Bool) throws -> buffer? {
        guard let v = v else { return nil }
        guard let key = key else { return nil }

        if doEncryption {
            fatalError("'AES128' encryption is not implemented yet.");
        }

        let keyData = key.getData()
        let data = v.getData()
        let result = try Cryptography.aesCBCDecrypt(data: data, keyData: keyData)
        return buffer(data: result!);  
    }
    
    public static func DEFLATE(_ v : buffer?, _ doEncryption: Bool) throws -> buffer? {
        guard let v = v else { fatalError("'DEFLATE' bad source data.") }
        let data = v.getData() as NSData?

        if doEncryption {
           guard let dd = data?.deflate() else { throw _exception_.create(0, "'DEFLATE' encryption: data is not decompressed.")! }
           return buffer(data: dd)
        } else {
           guard let di = data?.inflate() else { throw _exception_.create(0, "'DEFLATE' decryption: data is not decompressed.")! }
           return buffer(data: di)
        }
    }
}
