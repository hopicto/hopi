package com.hopi.web.security;

import java.awt.Color;
import java.awt.Font;
import java.awt.font.TextAttribute;
import java.awt.image.BufferedImage;
import java.text.AttributedString;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.hopi.web.WebConstants;
import com.octo.captcha.component.image.backgroundgenerator.BackgroundGenerator;
import com.octo.captcha.component.image.backgroundgenerator.FunkyBackgroundGenerator;
import com.octo.captcha.component.image.textpaster.NonLinearTextPaster;
import com.octo.captcha.component.image.textpaster.TextPaster;
import com.octo.captcha.component.word.wordgenerator.WordGenerator;

public class CaptchaController implements Controller {
	private final static Log log = LogFactory.getLog(CaptchaController.class);
	public static final Integer WORD_LENGTH = new Integer(4);
	private WordGenerator wordGenerator;

	public void setWordGenerator(WordGenerator wordGenerator) {
		this.wordGenerator = wordGenerator;
	}

	// // @RequestMapping("/commonCaptcha.do")
	// public void captcha(HttpServletRequest request, HttpServletResponse
	// response)
	// throws IOException {
	// String tag = request.getParameter("tag");
	// byte[] captchaChallengeAsJpeg = null;
	// ByteArrayOutputStream jpegOutputStream = new ByteArrayOutputStream();
	// try {
	//
	// String word = wordGenerator.getWord(WORD_LENGTH);
	// if (tag != null && tag.equals("regist")) {
	// request.getSession().setAttribute("regist", word);
	// } else {
	// request.getSession().setAttribute(WebConstants.JCAPTCHA_CODE,
	// word);
	// }
	// // log.info("session code=" + word);
	// TextPaster textPaster = new NonLinearTextPaster(new Integer(4),
	// new Integer(4), Color.blue);
	// BackgroundGenerator funkyBack = new FunkyBackgroundGenerator(
	// new Integer(80), new Integer(30));
	// AttributedString attributedWord = new AttributedString(word);
	// Font f = new Font("Arial", Font.TRUETYPE_FONT, 20);
	// attributedWord.addAttribute(TextAttribute.FONT, f);
	// BufferedImage image = textPaster.pasteText(funkyBack
	// .getBackground(), attributedWord);
	// JPEGImageEncoder jpegEncoder = JPEGCodec
	// .createJPEGEncoder(jpegOutputStream);
	// jpegEncoder.encode(image);
	// captchaChallengeAsJpeg = jpegOutputStream.toByteArray();
	// response.setHeader("Cache-Control", "no-store");
	// response.setHeader("Pragma", "no-cache");
	// response.setDateHeader("Expires", 0);
	// response.setContentType("image/jpeg");
	// ServletOutputStream responseOutputStream = response
	// .getOutputStream();
	// responseOutputStream.write(captchaChallengeAsJpeg);
	// responseOutputStream.flush();
	// responseOutputStream.close();
	// } catch (Exception e) {
	// log.error(e.getMessage());
	// response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	// } finally {
	// try {
	// jpegOutputStream.close();
	// } catch (Exception e) {
	// log.error(e.getMessage());
	// }
	// }
	// }

	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String tag = request.getParameter("tag");
		// byte[] captchaChallengeAsJpeg = null;
		// ByteArrayOutputStream jpegOutputStream = new ByteArrayOutputStream();
		try {

			String word = wordGenerator.getWord(WORD_LENGTH);
			if (tag != null && tag.equals("regist")) {
				request.getSession().setAttribute("regist", word);
			} else {
				request.getSession().setAttribute(WebConstants.JCAPTCHA_CODE,
						word);
			}
			log.info("session code=" + word);
			TextPaster textPaster = new NonLinearTextPaster(new Integer(4),
					new Integer(4), Color.blue);
			BackgroundGenerator funkyBack = new FunkyBackgroundGenerator(
					new Integer(80), new Integer(30));
			AttributedString attributedWord = new AttributedString(word);
			Font f = new Font("Arial", Font.TRUETYPE_FONT, 20);
			attributedWord.addAttribute(TextAttribute.FONT, f);
			BufferedImage image = textPaster.pasteText(funkyBack
					.getBackground(), attributedWord);

			// ImageIO.createImageInputStream(input)
			response.setHeader("Cache-Control", "no-store");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			response.setContentType("image/jpeg");

			ImageIO.write(image, "jpeg", response.getOutputStream());

			// JPEGImageEncoder jpegEncoder = JPEGCodec
			// .createJPEGEncoder(jpegOutputStream);
			// jpegEncoder.encode(image);

			// captchaChallengeAsJpeg = jpegOutputStream.toByteArray();

			// ServletOutputStream responseOutputStream = response
			// .getOutputStream();
			// // responseOutputStream.write(captchaChallengeAsJpeg);
			// responseOutputStream.flush();
			// responseOutputStream.close();
		} catch (Exception e) {
			log.error(e.getMessage());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
		// finally {
		// try {
		// response.getOutputStream().close();
		// } catch (Exception e) {
		// log.error(e.getMessage());
		// }
		// }
		return null;
	}
}
