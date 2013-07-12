/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.value;
import haxe.unit.TestCase;
import xpath.value.XPathNumber;
import xpath.value.XPathBoolean;
import xpath.value.XPathNodeSet;
import xpath.EvaluationException;


class XPathNumberTest extends TestCase {
	
	function testGetBool () {
		for (trueNumber in [
			1.0, -1.0, 385.0, 2.8, 0.7, -2483.0, -38.38,
			Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY
		]) {
			var xPathNumber = new XPathNumber(trueNumber);
			assertTrue(xPathNumber.getBool());
		}
		
		for (falseNumber in [ 0.0, #if !flash9 null, #end Math.NaN ]) {
			var xPathNumber = new XPathNumber(falseNumber);
			assertFalse(xPathNumber.getBool());
		}
	}
	
	function testGetFloat () {
		for (number in [ 0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38 ]) {
			var xPathNumber = new XPathNumber(number);
			assertEquals(number, xPathNumber.getFloat());
		} 
	}
	
	function testGetString () {
		for (number in [ 0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38 ]) {
			var xPathNumber = new XPathNumber(number);
			assertEquals(Std.string(number), xPathNumber.getString());
		} 
	}
	
	function testEquals () {
		for (leftOperand in [
			0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
		]) {
			for (rightOperand in [ 
				0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
			]) {
				var xPathLeft = new XPathNumber(leftOperand);
				var xPathRight = new XPathNumber(rightOperand);
				assertEquals(
					leftOperand == rightOperand,
					xPathLeft.equals(xPathRight).getBool()
				);
			}
		}
		
		var xPath0 = new XPathNumber(0);
		var xPath1 = new XPathNumber(1);
		var xPathFalse = new XPathBoolean(false);
		var xPathTrue = new XPathBoolean(true);
		assertTrue(xPath0.equals(xPathFalse).getBool());
		assertFalse(xPath0.equals(xPathTrue).getBool());
		assertFalse(xPath1.equals(xPathFalse).getBool());
		assertTrue(xPath1.equals(xPathTrue).getBool());
		assertTrue(xPathFalse.equals(xPath0).getBool());
		assertFalse(xPathFalse.equals(xPath1).getBool());
		assertFalse(xPathTrue.equals(xPath0).getBool());
		assertTrue(xPathTrue.equals(xPath1).getBool());
	}
	
	function testNotEqual () {
		for (leftOperand in [
			0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
		]) {
			for (rightOperand in [ 
				0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
			]) {
				var xPathLeft = new XPathNumber(leftOperand);
				var xPathRight = new XPathNumber(rightOperand);
				assertEquals(
					leftOperand != rightOperand,
					xPathLeft.notEqual(xPathRight).getBool()
				);
			}
		}
		
		var xPath0 = new XPathNumber(0);
		var xPath1 = new XPathNumber(1);
		var xPathFalse = new XPathBoolean(false);
		var xPathTrue = new XPathBoolean(true);
		assertFalse(xPath0.notEqual(xPathFalse).getBool());
		assertTrue(xPath0.notEqual(xPathTrue).getBool());
		assertTrue(xPath1.notEqual(xPathFalse).getBool());
		assertFalse(xPath1.notEqual(xPathTrue).getBool());
		assertFalse(xPathFalse.notEqual(xPath0).getBool());
		assertTrue(xPathFalse.notEqual(xPath1).getBool());
		assertTrue(xPathTrue.notEqual(xPath0).getBool());
		assertFalse(xPathTrue.notEqual(xPath1).getBool());
	}
	
	function testLessThanOrEqual () {
		for (leftOperand in [
			0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
		]) {
			for (rightOperand in [ 
				0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
			]) {
				var xPathLeft = new XPathNumber(leftOperand);
				var xPathRight = new XPathNumber(rightOperand);
				assertEquals(
					leftOperand <= rightOperand,
					xPathLeft.lessThanOrEqual(xPathRight).getBool()
				);
			}
		}
		
		var xPath0 = new XPathNumber(0);
		var xPath1 = new XPathNumber(1);
		var xPathFalse = new XPathBoolean(false);
		var xPathTrue = new XPathBoolean(true);
		assertTrue(xPath0.lessThanOrEqual(xPathFalse).getBool());
		assertTrue(xPath0.lessThanOrEqual(xPathTrue).getBool());
		assertFalse(xPath1.lessThanOrEqual(xPathFalse).getBool());
		assertTrue(xPath1.lessThanOrEqual(xPathTrue).getBool());
		assertTrue(xPathFalse.lessThanOrEqual(xPath0).getBool());
		assertTrue(xPathFalse.lessThanOrEqual(xPath1).getBool());
		assertFalse(xPathTrue.lessThanOrEqual(xPath0).getBool());
		assertTrue(xPathTrue.lessThanOrEqual(xPath1).getBool());
	}
	
	function testGreaterThanOrEqual () {
		for (leftOperand in [
			0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
		]) {
			for (rightOperand in [ 
				0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
			]) {
				var xPathLeft = new XPathNumber(leftOperand);
				var xPathRight = new XPathNumber(rightOperand);
				assertEquals(
					leftOperand >= rightOperand,
					xPathLeft.greaterThanOrEqual(xPathRight).getBool()
				);
			}
		}
		
		var xPath0 = new XPathNumber(0);
		var xPath1 = new XPathNumber(1);
		var xPathFalse = new XPathBoolean(false);
		var xPathTrue = new XPathBoolean(true);
		assertTrue(xPath0.greaterThanOrEqual(xPathFalse).getBool());
		assertFalse(xPath0.greaterThanOrEqual(xPathTrue).getBool());
		assertTrue(xPath1.greaterThanOrEqual(xPathFalse).getBool());
		assertTrue(xPath1.greaterThanOrEqual(xPathTrue).getBool());
		assertTrue(xPathFalse.greaterThanOrEqual(xPath0).getBool());
		assertFalse(xPathFalse.greaterThanOrEqual(xPath1).getBool());
		assertTrue(xPathTrue.greaterThanOrEqual(xPath0).getBool());
		assertTrue(xPathTrue.greaterThanOrEqual(xPath1).getBool());
	}
	
	function testLessThan () {
		for (leftOperand in [
			0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
		]) {
			for (rightOperand in [ 
				0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
			]) {
				var xPathLeft = new XPathNumber(leftOperand);
				var xPathRight = new XPathNumber(rightOperand);
				assertEquals(
					leftOperand < rightOperand,
					xPathLeft.lessThan(xPathRight).getBool()
				);
			}
		}
		
		var xPath0 = new XPathNumber(0);
		var xPath1 = new XPathNumber(1);
		var xPathFalse = new XPathBoolean(false);
		var xPathTrue = new XPathBoolean(true);
		assertFalse(xPath0.lessThan(xPathFalse).getBool());
		assertTrue(xPath0.lessThan(xPathTrue).getBool());
		assertFalse(xPath1.lessThan(xPathFalse).getBool());
		assertFalse(xPath1.lessThan(xPathTrue).getBool());
		assertFalse(xPathFalse.lessThan(xPath0).getBool());
		assertTrue(xPathFalse.lessThan(xPath1).getBool());
		assertFalse(xPathTrue.lessThan(xPath0).getBool());
		assertFalse(xPathTrue.lessThan(xPath1).getBool());
	}
	
	function testGreaterThan () {
		for (leftOperand in [
			0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
		]) {
			for (rightOperand in [ 
				0.0, 1.0, -1.0, 2.8, 0.7, -2483.0, -38.38
			]) {
				var xPathLeft = new XPathNumber(leftOperand);
				var xPathRight = new XPathNumber(rightOperand);
				assertEquals(
					leftOperand > rightOperand,
					xPathLeft.greaterThan(xPathRight).getBool()
				);
			}
		}
		
		var xPath0 = new XPathNumber(0);
		var xPath1 = new XPathNumber(1);
		var xPathFalse = new XPathBoolean(false);
		var xPathTrue = new XPathBoolean(true);
		assertFalse(xPath0.greaterThan(xPathFalse).getBool());
		assertFalse(xPath0.greaterThan(xPathTrue).getBool());
		assertTrue(xPath1.greaterThan(xPathFalse).getBool());
		assertFalse(xPath1.greaterThan(xPathTrue).getBool());
		assertFalse(xPathFalse.greaterThan(xPath0).getBool());
		assertFalse(xPathFalse.greaterThan(xPath1).getBool());
		assertTrue(xPathTrue.greaterThan(xPath0).getBool());
		assertFalse(xPathTrue.greaterThan(xPath1).getBool());
	}
	
	function testUnion () {
		var caught = false;
		try {
			new XPathNumber(123).union(new XPathNodeSet([]));
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
